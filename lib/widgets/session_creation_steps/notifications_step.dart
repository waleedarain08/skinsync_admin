import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/notification_entry.dart';
import 'package:skinsync_admin/models/notification_model.dart';
import 'package:skinsync_admin/models/responses/category_detail_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class NotificationsStep extends ConsumerWidget {
  const NotificationsStep({super.key});

  Widget _expandableSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Container(
            padding: context.appEdgeInsets(all: 8),
            decoration: BoxDecoration(
              color: CustomColors.purple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: CustomColors.purple, size: 18),
          ),
          title: Text(title, style: context.fonts.black16w600),
          children: [
            const Divider(height: 1),
            Padding(padding: context.appEdgeInsets(all: 24), child: content),
          ],
        ),
      ),
    );
  }

  Widget _radioOption(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (_) => onTap(),
            activeColor: CustomColors.purple,
          ),
          Text(label, style: context.fonts.black14w600),
        ],
      ),
    );
  }

  Widget _buildNotificationPreview(
    BuildContext context, {
    required String title,
    required String message,
    required String timing,
  }) {
    return Container(
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.fonts.grey10w700ls1),
              Container(
                padding: context.appEdgeInsets(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.1),
                  borderRadius: context.appBorderRadius(all: 4),
                ),
                child: Text(timing, style: context.fonts.purple12w700),
              ),
            ],
          ),
          context.verticalSpace(12),
          Text(message, style: context.fonts.black14w400),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SessionState state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);
    final selectedCategory = ref.watch(treatmentViewModelProvider).selectedCategoryDetail;

    return StatefulBuilder(
      builder: (context, setState) {
        Widget buildCategoryDefaultPreviews(
          List<NotificationModel> notifications, {
          required bool isPre,
        }) {
          if (notifications.isEmpty) {
            return Container(
              padding: context.appEdgeInsets(all: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border),
              ),
              child: Text(
                'No default notifications defined in this category.',
                style: context.fonts.grey14w400,
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => context.verticalSpace(12),
            itemBuilder: (context, idx) {
              final config = notifications[idx];
              final typeStr = typeValues.reverse[config.type] ?? 'reminder';
              final typeText =
                  ' [${typeStr[0].toUpperCase()}${typeStr.substring(1)}]';
              final timingUnitStr =
                  unitValues.reverse[config.timingUnit] ?? 'hours';
              return _buildNotificationPreview(
                context,
                title: '${config.title} $typeText (Read-only)',
                message: config.message,
                timing:
                    "${config.timing} $timingUnitStr ${isPre ? 'Before' : 'After'}",
              );
            },
          );
        }

        Widget buildCustomNotificationBuilder(
          List<NotificationEntry> entries,
          bool isPre,
        ) {
          final types = isPre
              ? ['reminder', 'warning', 'instruction']
              : ['recovery', 'care', 'follow-up reminder'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPre
                        ? 'Custom Pre Notifications'
                        : 'Custom Post Notifications',
                    style: context.fonts.black14w600,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (isPre) {
                          viewModel.addPreNotificationEntry();
                        } else {
                          viewModel.addPostNotificationEntry();
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: CustomColors.purple,
                    ),
                    label: const Text('Add Notification'),
                  ),
                ],
              ),
              context.verticalSpace(12),
              if (entries.isEmpty)
                Container(
                  width: double.infinity,
                  padding: context.appEdgeInsets(all: 16),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: context.appBorderRadius(all: 12),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Text(
                    "No custom notifications added. Tap 'Add Notification' to create one.",
                    style: context.fonts.grey13w500,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => context.verticalSpace(16),
                  itemBuilder: (context, idx) {
                    final entry = entries[idx];
                    return Container(
                      padding: context.appEdgeInsets(all: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: context.appBorderRadius(all: 12),
                        border: Border.all(color: CustomColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Notification #${idx + 1}',
                                style: context.fonts.purple14w700,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: CustomColors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (isPre) {
                                      viewModel.removePreNotificationEntry(idx);
                                    } else {
                                      viewModel.removePostNotificationEntry(
                                        idx,
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          context.verticalSpace(12),
                          BuildTextField(
                            label: 'Title',
                            controller: entry.titleController,
                            hintText: 'e.g. Avoid alcohol',
                          ),
                          context.verticalSpace(12),
                          BuildTextField(
                            label: 'Message Content',
                            controller: entry.messageController,
                            hintText: 'Enter notification message...',
                            maxLines: 2,
                          ),
                          context.verticalSpace(12),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: BuildTextField(
                                  label: 'Timing Value',
                                  controller: entry.timingValueController,
                                  hintText: 'e.g. 24',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              context.horizontalSpace(12),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Timing Unit',
                                      style: context.fonts.black14w600,
                                    ),
                                    context.verticalSpace(8),
                                    DropdownButtonHideUnderline(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: CustomColors.border,
                                          ),
                                        ),
                                        child: DropdownButton<String>(
                                          value: entry.timingUnit,
                                          isExpanded: true,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'minutes',
                                              child: Text('Minutes'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'hours',
                                              child: Text('Hours'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'days',
                                              child: Text('Days'),
                                            ),
                                          ],
                                          onChanged: (v) {
                                            if (v != null) {
                                              setState(() {
                                                entry.timingUnit = v;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          context.verticalSpace(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Type (Optional)',
                                style: context.fonts.black14w600,
                              ),
                              context.verticalSpace(8),
                              DropdownButtonHideUnderline(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: CustomColors.border,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: types.contains(entry.type) ? entry.type : types.first,
                                    isExpanded: true,
                                    items: types
                                        .map(
                                          (t) => DropdownMenuItem(
                                            value: t,
                                            child: Text(
                                              t[0].toUpperCase() +
                                                  t.substring(1),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() {
                                          entry.type = v;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          );
        }

        return Column(
          children: [
            _expandableSection(
              context,
              title: 'Pre-Treatment Notifications',
              icon: Icons.notifications_none_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notification Source', style: context.fonts.black14w600),
                  context.verticalSpace(12),
                  Row(
                    children: [
                      _radioOption(
                        context,
                        'Use Category Default',
                        state.preNotificationSource == 'category',
                        () {
                          setState(() {
                            viewModel.setPreNotificationSource(
                              'category',
                              category: selectedCategory,
                            );
                          });
                        },
                      ),
                      context.horizontalSpace(32),
                      _radioOption(
                        context,
                        'Create Custom',
                        state.preNotificationSource == 'custom',
                        () {
                          setState(() {
                            viewModel.setPreNotificationSource('custom');
                          });
                        },
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  if (state.preNotificationSource == 'category') ...[
                    buildCategoryDefaultPreviews(
                      selectedCategory?.preNotifications ?? [],
                      isPre: true,
                    ),
                  ] else ...[
                    buildCustomNotificationBuilder(
                      state.preNotificationEntries,
                      true,
                    ),
                  ],
                ],
              ),
            ),
            context.verticalSpace(24),
            _expandableSection(
              context,
              title: 'Post-Treatment Notifications',
              icon: Icons.notifications_active_outlined,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notification Source', style: context.fonts.black14w600),
                  context.verticalSpace(12),
                  Row(
                    children: [
                      _radioOption(
                        context,
                        'Use Category Default',
                        state.postNotificationSource == 'category',
                        () {
                          setState(() {
                            viewModel.setPostNotificationSource(
                              'category',
                              category: selectedCategory,
                            );
                          });
                        },
                      ),
                      context.horizontalSpace(32),
                      _radioOption(
                        context,
                        'Create Custom',
                        state.postNotificationSource == 'custom',
                        () {
                          setState(() {
                            viewModel.setPostNotificationSource('custom');
                          });
                        },
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  if (state.postNotificationSource == 'category') ...[
                    buildCategoryDefaultPreviews(
                      selectedCategory?.postNotifications ?? [],
                      isPre: false,
                    ),
                  ] else ...[
                    buildCustomNotificationBuilder(
                      state.postNotificationEntries,
                      false,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}