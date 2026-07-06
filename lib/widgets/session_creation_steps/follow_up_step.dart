import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';

class FollowUpStep extends ConsumerWidget {
  const FollowUpStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  Widget _buildFollowUpEntryCardV2(
    BuildContext context,
    int sIdx,
    int fuIdx,
    FollowUpEntry entry,
    SessionViewModel viewModel,
  ) {
    return Container(
      padding: context.appEdgeInsets(all: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 16),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.1),
                  borderRadius: context.appBorderRadius(all: 20),
                ),
                child: Text(
                  'Follow-Up ${fuIdx + 1}',
                  style: context.fonts.purple12w700,
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  label: 'Appointment Type',
                  hintText: 'Select type',
                  value: entry.type.isEmpty ? null : entry.type,
                  items: const [
                    DropdownMenuItem(value: 'virtual', child: Text('Virtual')),
                    DropdownMenuItem(
                      value: 'in_person',
                      child: Text('In-Person'),
                    ),
                  ],
                  onChanged: (val) => viewModel.updateSessionFollowUpEntry(
                    sIdx,
                    fuIdx,
                    type: val,
                  ),
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Duration', style: context.fonts.black14w600),
                    context.verticalSpace(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: entry.durationValueController,
                            keyboardType: TextInputType.number,
                            decoration: AppDecorations.input(
                              context,
                              hint: '30',
                            ),
                            onChanged: (v) => viewModel
                                .updateSessionFollowUpEntry(sIdx, fuIdx),
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: DropdownButton<String>(
                                value: entry.durationUnit.isEmpty ? 'minutes' : entry.durationUnit,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: CustomColors.grey,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'minutes',
                                    child: Text('Minutes'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'hours',
                                    child: Text('Hours'),
                                  ),
                                ],
                                onChanged: (val) =>
                                    viewModel.updateSessionFollowUpEntry(
                                      sIdx,
                                      fuIdx,
                                      durationUnit: val,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scheduling Interval',
                      style: context.fonts.black14w600,
                    ),
                    context.verticalSpace(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: entry.intervalValueController,
                            keyboardType: TextInputType.number,
                            decoration: AppDecorations.input(
                              context,
                              hint: '1',
                            ),
                            onChanged: (v) => viewModel
                                .updateSessionFollowUpEntry(sIdx, fuIdx),
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: DropdownButton<String>(
                                value: entry.intervalUnit.isEmpty ? 'days' : entry.intervalUnit,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: CustomColors.grey,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'days',
                                    child: Text('Days After'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'weeks',
                                    child: Text('Weeks After'),
                                  ),
                                ],
                                onChanged: (val) =>
                                    viewModel.updateSessionFollowUpEntry(
                                      sIdx,
                                      fuIdx,
                                      intervalUnit: val,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Requirements', style: context.fonts.black14w600),
                    context.verticalSpace(10),
                    Container(
                      padding: context.appEdgeInsets(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: context.appBorderRadius(all: 8),
                        border: Border.all(color: CustomColors.border),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: entry.isImageRequired,
                            activeColor: CustomColors.purple,
                            onChanged: (val) =>
                                viewModel.updateSessionFollowUpEntry(
                                  sIdx,
                                  fuIdx,
                                  isImageRequired: val ?? false,
                                ),
                          ),
                          Text(
                            'Image Required',
                            style: context.fonts.black14w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          BuildTextField(
            label: 'Clinical Notes',
            controller: entry.notesController,
            hintText: 'Specific instructions for this follow-up...',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(sessionViewModelProvider.notifier);
    final sessionState = ref.watch(sessionViewModelProvider);

    final int sIdx = sessionState.activeSessionIndex;
    if (sIdx >= sessionState.sessions.length) {
      return const SizedBox.shrink();
    }
    final session = sessionState.sessions[sIdx];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Follow-Up Configuration'),
        context.verticalSpace(8),
        Text(
          'Configure dedicated clinical check-ins and follow-ups.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: context.appEdgeInsets(all: 20),
              decoration: BoxDecoration(
                color: CustomColors.purple.withValues(alpha: 0.05),
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(
                  color: CustomColors.purple.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_note_rounded,
                    color: CustomColors.purple,
                  ),
                  context.horizontalSpace(12),
                  Text(
                    'Total Follow-Ups',
                    style: context.fonts.purple14w700,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: context.w(150),
                    child: BuildTextField(
                      label: 'Follow-Ups',
                      controller: session.totalFollowUpsController,
                      hintText: '0',
                      keyboardType: TextInputType.number,
                      onChanged: (val) => viewModel
                          .updateSessionFollowUpCount(sIdx, val ?? '0'),
                    ),
                  ),
                ],
              ),
            ),
            if (session.followUps.isNotEmpty) ...[
              context.verticalSpace(20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: session.followUps.length,
                separatorBuilder: (_, _) => context.verticalSpace(16),
                itemBuilder: (context, fuIdx) {
                  return _buildFollowUpEntryCardV2(
                    context,
                    sIdx,
                    fuIdx,
                    session.followUps[fuIdx],
                    viewModel,
                  );
                },
              ),
            ],
            context.verticalSpace(32),
          ],
        ),
      ],
    );
  }
}