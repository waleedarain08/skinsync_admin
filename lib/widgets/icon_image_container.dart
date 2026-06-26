import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'app_network_image.dart';

class IconImageContainer extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final String? iconUrl;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onAddChild;
  final VoidCallback? onViewDetail;
  final double? width;
  final double? height;
  final bool showActions;

  const IconImageContainer({
    super.key,
    this.title,
    this.imageUrl,
    this.iconUrl,
    this.isSelected = false,
    this.onTap,
    this.onAddChild,
    this.onViewDetail,
    this.width,
    this.height,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = width ?? context.w(180);
    final double cardHeight = height ?? context.h(130);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: context.appBorderRadius(all: 16),
          border: Border.all(
            color: isSelected ? CustomColors.purple : CustomColors.border,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CustomColors.purple.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppShadows.xs(context),
        ),
        child: ClipRRect(
          borderRadius: context.appBorderRadius(all: 14), // Account for border width
          child: Stack(
            children: [
              // 1. Full-Cover Image Background
              Positioned.fill(
                child: AppNetworkImage(
                  imageUrl: imageUrl ?? '',
                  fit: BoxFit.cover,
                  placeholderColor: CustomColors.whiteGrey,
                ),
              ),

              // 2. Selection Tint / Dark Overlay Gradient for readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isSelected
                          ? [
                              CustomColors.purple.withValues(alpha: 0.25),
                              CustomColors.purple.withValues(alpha: 0.65),
                              CustomColors.purple.withValues(alpha: 0.9),
                            ]
                          : [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.35),
                              Colors.black.withValues(alpha: 0.7),
                            ],
                    ),
                  ),
                ),
              ),

              // 3. Title Aligned to Bottom
              if (title != null && title!.isNotEmpty)
                Positioned(
                  bottom: context.h(12),
                  left: context.w(12),
                  right: context.w(12),
                  child: Text(
                    title!,
                    style: context.fonts.white14w600.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // 4. Icon/Thumbnail Container on Top Left
              if (iconUrl != null && iconUrl!.isNotEmpty)
                Positioned(
                  top: context.h(10),
                  left: context.w(10),
                  child: Container(
                    width: context.w(28),
                    height: context.w(28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: AppNetworkImage(
                        imageUrl: iconUrl!,
                        fit: BoxFit.cover,
                        errorIcon: Icons.broken_image,
                      ),
                    ),
                  ),
                ),

              // 5. Action Buttons on Top Right
              if (showActions)
                Positioned(
                  top: context.h(10),
                  right: context.w(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onViewDetail != null)
                        GestureDetector(
                          onTap: onViewDetail,
                          child: Container(
                            padding: EdgeInsets.all(context.w(4)),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.visibility_outlined,
                              size: context.sp(12),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (onViewDetail != null && onAddChild != null)
                        context.horizontalSpace(6),
                      if (onAddChild != null)
                        GestureDetector(
                          onTap: onAddChild,
                          child: Container(
                            padding: EdgeInsets.all(context.w(4)),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              size: context.sp(12),
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}