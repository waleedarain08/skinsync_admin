import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class StandardDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final double? width;
  final bool showCloseIcon;

  const StandardDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.width,
    this.showCloseIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: context.appEdgeInsets(horizontal: 24),
      child: Container(
        width: width ?? context.w(520),
        padding: context.appEdgeInsets(all: 24),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: context.appBorderRadius(all: 16),
          border: Border.all(color: CustomColors.border),
          boxShadow: AppShadows.lg(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: context.fonts.black18w600)),
                if (showCloseIcon)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, size: context.sp(20), color: CustomColors.lightGrey),
                    style: IconButton.styleFrom(
                      backgroundColor: CustomColors.whiteGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: context.appBorderRadius(all: 8),
                      ),
                    ),
                  ),
              ],
            ),
            context.verticalSpace(20),
            Flexible(
              child: SingleChildScrollView(
                child: content,
              ),
            ),
            if (actions != null) ...[
              context.verticalSpace(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map((action) => Padding(
                          padding: context.appEdgeInsets(left: 12),
                          child: action,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
