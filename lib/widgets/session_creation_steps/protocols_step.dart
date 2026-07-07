import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';

class ProtocolsStep extends ConsumerWidget {
  const ProtocolsStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  void _showAddProtocolDialog(
    BuildContext context,
    WidgetRef ref,
    ProtocolType type,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title:
            "Add ${type == ProtocolType.checkbox ? 'Checkbox' : 'Text'} Protocol",
        width: context.w(450),
        content: BuildTextField(
          label: 'Protocol Title',
          controller: controller,
          hintText:
              "e.g. ${type == ProtocolType.checkbox ? 'Cleanse treatment area' : 'Pre-Treatment Instructions'}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomPrimaryButton(
            onTap: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(treatmentDataViewModelProvider.notifier)
                    .addProtocol(controller.text.trim(), type);
                Navigator.pop(context);
              }
            },
            label: 'Save Protocol',
            width: context.w(150),
          ),
        ],
      ),
    );
  }

  void _showStandaloneNoteEditDialog(
    BuildContext context,
    int? editIndex,
    TreatmentProtocolNoteItem? existingNote,
    SessionViewModel viewModel,
    List<TreatmentProtocolNoteItem> currentNotes,
  ) {
    final titleController = TextEditingController(text: existingNote?.title);
    final descController = TextEditingController(
      text: existingNote?.description,
    );

    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: editIndex == null
            ? 'Add Note / Instruction'
            : 'Edit Note / Instruction',
        width: context.w(450),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildTextField(
              label: 'Title (Optional)',
              controller: titleController,
              hintText: 'e.g. Pre Care Instructions',
            ),
            context.verticalSpace(16),
            BuildTextField(
              label: 'Note / Description',
              controller: descController,
              hintText: 'e.g. Avoid retinol 3 days before treatment',
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomPrimaryButton(
            onTap: () {
              if (descController.text.trim().isNotEmpty) {
                final updated = List<TreatmentProtocolNoteItem>.from(
                  currentNotes,
                );
                final newNote = TreatmentProtocolNoteItem(
                  title: titleController.text.trim().isEmpty
                      ? null
                      : titleController.text.trim(),
                  description: descController.text.trim(),
                  order: editIndex == null
                      ? currentNotes.length + 1
                      : existingNote!.order,
                );

                if (editIndex == null) {
                  updated.add(newNote);
                } else {
                  updated[editIndex] = newNote;
                }

                viewModel.updateStandaloneNotes(updated);
                Navigator.pop(context);
              }
            },
            label: 'Save',
            width: context.w(120),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolGroup(
    BuildContext context, {
    required String title,
    required List<ProtocolItem> protocols,
    required List<String> selectedIds,
    required void Function(String) onToggle,
    required VoidCallback onAdd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: context.fonts.black16w600),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: CustomColors.purple,
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        context.verticalSpace(16),
        if (protocols.isEmpty)
          Container(
            width: double.infinity,
            padding: context.appEdgeInsets(all: 20),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: Text(
              'No protocols in this group.',
              style: context.fonts.grey13w500,
            ),
          )
        else
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: protocols.map((protocol) {
              final isSelected = selectedIds.contains(protocol.id);
              return InkWell(
                onTap: () => onToggle(protocol.id),
                borderRadius: context.appBorderRadius(all: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CustomColors.purple.withValues(alpha: 0.08)
                        : Colors.white,
                    borderRadius: context.appBorderRadius(all: 10),
                    border: Border.all(
                      color: isSelected
                          ? CustomColors.purple
                          : CustomColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        size: 18,
                        color: isSelected
                            ? CustomColors.purple
                            : CustomColors.grey,
                      ),
                      context.horizontalSpace(10),
                      Text(
                        protocol.title,
                        style: isSelected
                            ? context.fonts.purple14w600
                            : context.fonts.black14w400,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildJourneyProtocols(
    BuildContext context,
    TreatmentDataState dataState,
    WidgetRef ref,
    List<String> selectedIds,
    void Function(String) onToggle,
  ) {
    final checkboxProtocols = dataState.protocols
        .where((p) => p.type == ProtocolType.checkbox)
        .toList();
    final textProtocols = dataState.protocols
        .where((p) => p.type == ProtocolType.text)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProtocolGroup(
          context,
          title: 'Checkboxes',
          protocols: checkboxProtocols,
          selectedIds: selectedIds,
          onToggle: onToggle,
          onAdd: () =>
              _showAddProtocolDialog(context, ref, ProtocolType.checkbox),
        ),
        context.verticalSpace(24),
        _buildProtocolGroup(
          context,
          title: 'Text Fields',
          protocols: textProtocols,
          selectedIds: selectedIds,
          onToggle: onToggle,
          onAdd: () => _showAddProtocolDialog(context, ref, ProtocolType.text),
        ),
      ],
    );
  }

  Widget _buildStandaloneNotesSection(
    BuildContext context,
    SessionState state,
    SessionViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle(context, 'Notes / Instructions'),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: CustomColors.purple,
                  size: 24,
                ),
                onPressed: () => _showStandaloneNoteEditDialog(
                  context,
                  null,
                  null,
                  viewModel,
                  state.standaloneNotes,
                ),
              ),
            ],
          ),
          if (state.standaloneNotes.isNotEmpty) ...[
            context.verticalSpace(16),
            const Divider(),
            context.verticalSpace(16),
            ...state.standaloneNotes.asMap().entries.map((entry) {
              final idx = entry.key;
              final note = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (note.title != null && note.title!.isNotEmpty)
                          Text(
                            note.title!,
                            style: context.fonts.black14w600,
                          )
                        else
                          Text(
                            'Note #${idx + 1}',
                            style: context.fonts.grey14w400,
                          ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_upward, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: idx > 0
                                  ? () {
                                      final updated =
                                          List<TreatmentProtocolNoteItem>.from(
                                        state.standaloneNotes,
                                      );
                                      final temp = updated[idx];
                                      updated[idx] = updated[idx - 1];
                                      updated[idx - 1] = temp;
                                      viewModel.updateStandaloneNotes(updated);
                                    }
                                  : null,
                            ),
                            context.horizontalSpace(8),
                            IconButton(
                              icon: const Icon(Icons.arrow_downward, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: idx < state.standaloneNotes.length - 1
                                  ? () {
                                      final updated =
                                          List<TreatmentProtocolNoteItem>.from(
                                        state.standaloneNotes,
                                      );
                                      final temp = updated[idx];
                                      updated[idx] = updated[idx + 1];
                                      updated[idx + 1] = temp;
                                      viewModel.updateStandaloneNotes(updated);
                                    }
                                  : null,
                            ),
                            context.horizontalSpace(12),
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: CustomColors.purple,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => _showStandaloneNoteEditDialog(
                                context,
                                idx,
                                note,
                                viewModel,
                                state.standaloneNotes,
                              ),
                            ),
                            context.horizontalSpace(12),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: CustomColors.red,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                final updated =
                                    List<TreatmentProtocolNoteItem>.from(
                                  state.standaloneNotes,
                                );
                                updated.removeAt(idx);
                                viewModel.updateStandaloneNotes(updated);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    context.verticalSpace(8),
                    Text(
                      note.description,
                      style: context.fonts.black14w400,
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);

    final selectedProtocols = state.selectedProtocolIds
        .map((id) => dataState.protocols.any((p) => p.id == id)
            ? dataState.protocols.firstWhere((p) => p.id == id)
            : null)
        .whereType<ProtocolItem>()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildJourneyProtocols(
          context,
          dataState,
          ref,
          state.selectedProtocolIds,
          (id) {
            final pItem = dataState.protocols.firstWhere((p) => p.id == id);
            viewModel.toggleProtocolSelection(
              id,
              protocolName: pItem.title,
              masterProtocols: dataState.protocols,
            );
          },
        ),
        if (selectedProtocols.isNotEmpty) ...[
          context.verticalSpace(32),
          _sectionTitle(context, 'Protocol Notes & Instructions'),
          context.verticalSpace(8),
          Text(
            'Add custom step-by-step notes and clinical guidelines for each selected protocol.',
            style: context.fonts.grey14w400,
          ),
          context.verticalSpace(16),
          ...selectedProtocols.asMap().entries.map((entry) {
            final idx = entry.key;
            final protocol = entry.value;
            final noteEntry = state.selectedProtocolNotes.firstWhere(
              (n) => n.protocolName == protocol.title,
              orElse: () => TreatmentProtocolNote(
                protocolName: protocol.title,
                notes: [],
              ),
            );
            return ProtocolNotesCard(
              key: ValueKey('note_${protocol.id}_${noteEntry.notes.length}'),
              protocol: protocol,
              initialNotes: noteEntry.notes,
              onNotesChanged: (updatedNotes) {
                viewModel.updateProtocolNotes(protocol.title, updatedNotes);
              },
              onMoveUp: idx > 0 ? () {
                final updatedIds = List<String>.from(state.selectedProtocolIds);
                final temp = updatedIds[idx];
                updatedIds[idx] = updatedIds[idx - 1];
                updatedIds[idx - 1] = temp;
                viewModel.updateSelectedProtocolIds(updatedIds);
              } : null,
              onMoveDown: idx < selectedProtocols.length - 1 ? () {
                final updatedIds = List<String>.from(state.selectedProtocolIds);
                final temp = updatedIds[idx];
                updatedIds[idx] = updatedIds[idx + 1];
                updatedIds[idx + 1] = temp;
                viewModel.updateSelectedProtocolIds(updatedIds);
              } : null,
            );
          }),
        ],
        context.verticalSpace(40),
        _buildStandaloneNotesSection(context, state, viewModel),
      ],
    );
  }
}

class ProtocolNotesCard extends StatefulWidget {
  final ProtocolItem protocol;
  final List<TreatmentProtocolNoteItem> initialNotes;
  final void Function(List<TreatmentProtocolNoteItem>) onNotesChanged;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  const ProtocolNotesCard({
    super.key,
    required this.protocol,
    required this.initialNotes,
    required this.onNotesChanged,
    this.onMoveUp,
    this.onMoveDown,
  });

  @override
  State<ProtocolNotesCard> createState() => _ProtocolNotesCardState();
}

class _ProtocolNotesCardState extends State<ProtocolNotesCard> {
  late List<Map<String, TextEditingController>> _noteControllers;

  @override
  void initState() {
    super.initState();
    _noteControllers = widget.initialNotes
        .map(
          (note) => {
            'title': TextEditingController(text: note.title),
            'description': TextEditingController(text: note.description),
          },
        )
        .toList();
  }

  @override
  void dispose() {
    for (final note in _noteControllers) {
      note['title']?.dispose();
      note['description']?.dispose();
    }
    super.dispose();
  }

  void _notify() {
    final List<TreatmentProtocolNoteItem> updatedNotes = [];
    for (int i = 0; i < _noteControllers.length; i++) {
      final title = _noteControllers[i]['title']!.text.trim();
      final desc = _noteControllers[i]['description']!.text.trim();
      updatedNotes.add(
        TreatmentProtocolNoteItem(
          title: title.isEmpty ? null : title,
          description: desc,
          order: i + 1,
        ),
      );
    }
    widget.onNotesChanged(updatedNotes);
  }

  @override
  Widget build(BuildContext context) {
    return BorderdContainerWidget(
      margin: const EdgeInsets.only(top: 16),
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.assignment_turned_in_outlined,
                      color: CustomColors.purple,
                      size: 20,
                    ),
                    context.horizontalSpace(12),
                    Expanded(
                      child: Text(
                        widget.protocol.title,
                        style: context.fonts.black16w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.onMoveUp != null || widget.onMoveDown != null) ...[
                      context.horizontalSpace(8),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward_rounded, size: 16, color: CustomColors.grey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: widget.onMoveUp,
                      ),
                      context.horizontalSpace(4),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward_rounded, size: 16, color: CustomColors.grey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: widget.onMoveDown,
                      ),
                    ],
                  ],
                ),
              ),
              context.horizontalSpace(16),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _noteControllers.add({
                      'title': TextEditingController(),
                      'description': TextEditingController(),
                    });
                  });
                  _notify();
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Protocol Note'),
                style: TextButton.styleFrom(
                  foregroundColor: CustomColors.purple,
                ),
              ),
            ],
          ),
          if (_noteControllers.isNotEmpty) ...[
            context.verticalSpace(16),
            const Divider(),
            context.verticalSpace(16),
            ..._noteControllers.asMap().entries.map((entry) {
              final idx = entry.key;
              final controllers = entry.value;
              final titleCtrl = controllers['title']!;
              final descCtrl = controllers['description']!;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Note #${idx + 1}',
                          style: context.fonts.black14w600,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_upward, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: idx > 0
                                  ? () {
                                      setState(() {
                                        final temp = _noteControllers[idx];
                                        _noteControllers[idx] =
                                            _noteControllers[idx - 1];
                                        _noteControllers[idx - 1] = temp;
                                      });
                                      _notify();
                                    }
                                  : null,
                            ),
                            context.horizontalSpace(8),
                            IconButton(
                              icon: const Icon(Icons.arrow_downward, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: idx < _noteControllers.length - 1
                                  ? () {
                                      setState(() {
                                        final temp = _noteControllers[idx];
                                        _noteControllers[idx] =
                                            _noteControllers[idx + 1];
                                        _noteControllers[idx + 1] = temp;
                                      });
                                      _notify();
                                    }
                                  : null,
                            ),
                            context.horizontalSpace(12),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: CustomColors.red,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setState(() {
                                  _noteControllers[idx]['title']!.dispose();
                                  _noteControllers[idx]['description']!
                                      .dispose();
                                  _noteControllers.removeAt(idx);
                                });
                                _notify();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    context.verticalSpace(12),
                    BuildTextField(
                      label: 'Title (Optional)',
                      controller: titleCtrl,
                      hintText: 'e.g. Pre Care',
                      onChanged: (_) => _notify(),
                    ),
                    context.verticalSpace(12),
                    BuildTextField(
                      label: 'Description (Required)',
                      controller: descCtrl,
                      hintText: 'Enter protocol instruction notes...',
                      maxLines: 2,
                      onChanged: (_) => _notify(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}