import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/create_session_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/treatment_session_expansion_tile.dart';

class SessionsStep extends ConsumerStatefulWidget {
  const SessionsStep({super.key});

  @override
  ConsumerState<SessionsStep> createState() => _SessionsStepState();
}

class _SessionsStepState extends ConsumerState<SessionsStep> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = ref.read(treatmentViewModelProvider);
      final treatmentId = state.selectedTreatment?.id;
      final areaId = state.selectedTreatmentAreaIds.isNotEmpty
          ? state.selectedTreatmentAreaIds.last
          : null;

      if (treatmentId != null && areaId != null) {
        await ref
            .read(sessionViewModelProvider.notifier)
            .fetchSessions(treatmentId: treatmentId, areaId: areaId);
      }
    });
  }

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  void _showAddSessionDialog(
    BuildContext context,
    SessionViewModel sessionViewModel,
    TreatmentState state,
  ) {
    final titleController = TextEditingController();
    final numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.appBorderRadius(all: 16),
          ),
          title: Text('Add Clinical Session', style: context.fonts.black16w600),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BuildTextField(
                controller: titleController,
                label: 'Session Title',
                hintText: 'e.g., Session 1 - Introduction',
              ),
              context.verticalSpace(16),
              BuildTextField(
                controller: numberController,
                label: 'Session Number',
                hintText: 'e.g., 1',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: context.fonts.grey14w500),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final numberStr = numberController.text.trim();
                final number = int.tryParse(numberStr);

                if (title.isEmpty || number == null || number <= 0) {
                  EasyLoading.showError('Please fill out all fields correctly.');
                  return;
                }

                final treatmentId = state.selectedTreatment?.id;
                final areaId = state.selectedTreatmentAreaIds.isNotEmpty
                    ? state.selectedTreatmentAreaIds.last
                    : null;

                if (treatmentId == null || areaId == null) {
                  EasyLoading.showError('Treatment ID or Area ID is missing.');
                  return;
                }

                Navigator.pop(context);
                EasyLoading.show(status: 'Creating session...');

                final success = await sessionViewModel.createSession(
                  treatmentId: treatmentId,
                  areaId: areaId,
                  title: title,
                  sessionNumber: number,
                );

                if (success == true) {
                  EasyLoading.showSuccess('Session added successfully!');
                  await sessionViewModel.fetchSessions(
                    treatmentId: treatmentId,
                    areaId: areaId,
                  );
                } else {
                  EasyLoading.showError('Failed to create session.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 8),
                ),
              ),
              child: Text('Add', style: context.fonts.white12w700),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final sessionState = ref.watch(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'Sessions Setup & Blueprint'),
                context.verticalSpace(4),
                Text(
                  'Define and configure custom clinical session steps for each target area.',
                  style: context.fonts.grey14w400,
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddSessionDialog(
                context,
                sessionViewModel,
                state,
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: Text('Add Session', style: context.fonts.white14w600),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.purple,
                padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 8),
                ),
              ),
            ),
          ],
        ),
        context.verticalSpace(32),

        if (sessionState.sessions.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: context.appEdgeInsets(all: 32),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.layers_clear_outlined,
                  color: CustomColors.grey,
                  size: 40,
                ),
                context.verticalSpace(12),
                Text(
                  'No sessions configured for this treatment yet.',
                  style: context.fonts.black14w600,
                ),
                Text(
                  'Click "Add Session" to add a new clinical session card.',
                  style: context.fonts.grey12w400,
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: context.appEdgeInsets(all: 20),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: Column(
              children: List.generate(sessionState.sessions.length, (index) {
                final sessionEntry = sessionState.sessions[index];
                return TreatmentSessionExpansionTile(
                  sessionEntry: sessionEntry,
                  index: index,
                  onExpansionChanged: (expanded) async {
                    if (expanded && sessionEntry.sessionId != null) {
                      await sessionViewModel.fetchAndPopulateSessionDetail(
                        sessionEntry.sessionId!,
                      );
                    }
                  },
                  onEditDetail: () async {
                    sessionViewModel.reset();
                    sessionViewModel.setActiveSessionIndex(index);
                    if (sessionEntry.sessionId != null) {
                      final success = await sessionViewModel
                          .fetchAndPopulateSessionDetail(
                            sessionEntry.sessionId!,
                          );
                      if (success && context.mounted) {
                        context.push(CreateSessionScreen.routeName);
                      }
                    } else {
                      sessionViewModel.setSessionStep(1);
                      context.push(CreateSessionScreen.routeName);
                    }
                  },
                  onDelete: () async {
                    if (sessionEntry.sessionId != null) {
                      await sessionViewModel.deleteSession(
                        sessionId: sessionEntry.sessionId!,
                      );
                    }
                    sessionViewModel.removeCustomSession(index);
                  },
                );
              }),
            ),
          ),
        ],
      ],
    );
  }
}
