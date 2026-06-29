import 'package:flutter/material.dart';
import 'package:skinsync_admin/widgets/app_loader.dart';
import '../utils/color_constant.dart';
import '../utils/theme.dart';

class SelectOrCreateDropdown<T> extends StatefulWidget {
  final String label;
  final String hint;
  final T? value;
  final bool showAddIcon;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final VoidCallback onCreate;
  final Future<void> Function()? onOpen; // API call triggered on dropdown open

  const SelectOrCreateDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    required this.onCreate,
    this.showAddIcon = false,
    this.onOpen,
  });

  @override
  State<SelectOrCreateDropdown<T>> createState() =>
      _SelectOrCreateDropdownState<T>();
}

class _SelectOrCreateDropdownState<T> extends State<SelectOrCreateDropdown<T>> {
  final MenuController _menuController = MenuController();
  bool _isLoading = false;

  Future<void> _handleOpen() async {
    if (widget.onOpen != null && widget.items.isEmpty) {
      setState(() => _isLoading = true);
      await widget.onOpen!();
      if (mounted) setState(() => _isLoading = false);
    }
    _menuController.open();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.value != null
        ? widget.itemLabel(widget.value as T)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label + Add button ───────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: context.fonts.black14w600),
            if (widget.showAddIcon)
              IconButton(
                onPressed: widget.onCreate,
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: CustomColors.purple,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        LayoutBuilder(
          builder: (context, constraints) {
            return MenuAnchor(
              controller: _menuController,
              crossAxisUnconstrained: false,
              alignmentOffset: const Offset(0, 4),
              style: MenuStyle(
                backgroundColor: const WidgetStatePropertyAll(
                  CustomColors.white,
                ),
                surfaceTintColor: const WidgetStatePropertyAll(
                  CustomColors.white,
                ),
                // ── Force menu width to match parent ──────────────────
                minimumSize: WidgetStatePropertyAll(
                  Size(constraints.maxWidth, 0),
                ),
                maximumSize: WidgetStatePropertyAll(
                  Size(constraints.maxWidth, 300.h),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: CustomColors.border),
                  ),
                ),
                elevation: const WidgetStatePropertyAll(4),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 4.h),
                ),
              ),
              menuChildren: _isLoading
                  ? [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppLoader(size: 36.h),
                        ),
                      ),
                    ]
                  : widget.items.isEmpty
                  ? [
                      SizedBox(
                        width: constraints.maxWidth,
                        height: 60.h,
                        child: Center(
                          child: Text(
                            'No items found',
                            style: context.fonts.grey12w400,
                          ),
                        ),
                      ),
                    ]
                  : widget.items.map((item) {
                      final isSelected = widget.value == item;
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: MenuItemButton(
                          onPressed: () {
                            widget.onChanged(item);
                            _menuController.close();
                          },
                          style: ButtonStyle(
                            minimumSize: WidgetStatePropertyAll(
                              Size(constraints.maxWidth, 48.h),
                            ),
                            maximumSize: WidgetStatePropertyAll(
                              Size(constraints.maxWidth, 60.h),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              isSelected
                                  ? CustomColors.purple.withValues(alpha: 0.08)
                                  : Colors.transparent,
                            ),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.itemLabel(item),
                                  style: isSelected
                                      ? context.fonts.black14w600.copyWith(
                                          color: CustomColors.purple,
                                        )
                                      : context.fonts.black14w400,
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_rounded,
                                  size: 16.sp,
                                  color: CustomColors.purple,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

              // ── Trigger button ───────────────────────────────────────
              builder: (context, controller, child) {
                return GestureDetector(
                  onTap: _handleOpen,
                  child: Container(
                    width: constraints.maxWidth,
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      border: Border.all(color: CustomColors.border),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayText ?? widget.hint,
                            style: displayText != null
                                ? context.fonts.black14w400
                                : context.fonts.grey14w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        /*  _isLoading
                            ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: const CircularProgressIndicator(
                            color: CustomColors.purple,
                            strokeWidth: 2,
                            constraints: BoxConstraints(
                              maxWidth: 16,
                              maxHeight: 16,
                            ),
                          ),
                        )
                            : */
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: CustomColors.lightGrey,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
