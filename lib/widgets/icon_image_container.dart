import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'app_network_image.dart';

class IconImageContainer extends StatelessWidget {
  final String? iconUrl;
  final double? width;
  final double? height;
  final double? borderRadius;
  final IconData? errorIcon;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;

  const IconImageContainer({
    super.key,
    this.iconUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.errorIcon,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final double computedWidth = width ?? context.w(38);
    final double computedHeight = height ?? context.w(38);
    final double computedRadius = borderRadius ?? 10;
    final Color computedBorderColor = borderColor ?? Colors.white;
    final double computedBorderWidth = borderWidth ?? 1.5;
    final IconData computedErrorIcon = errorIcon ?? Icons.broken_image;

    final bool isUrl = iconUrl != null && iconUrl!.startsWith('http');

    return Container(
      margin: margin ?? EdgeInsets.only(bottom: context.h(4)),
      decoration: BoxDecoration(
        borderRadius: context.appBorderRadius(all: computedRadius),
        border: Border.all(
            color: computedBorderColor, width: computedBorderWidth),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: context.appBorderRadius(all: computedRadius),
        child: isUrl
            ? AppNetworkImage(
          imageUrl: iconUrl!,
          width: computedWidth,
          height: computedHeight,
          fit: BoxFit.cover,
          errorIcon: computedErrorIcon,
        )
            : Container(
          width: computedWidth,
          height: computedHeight,
          color: CustomColors.whiteGrey,
          alignment: Alignment.center,
          child: Icon(
            _getIconData(iconUrl),
            size: computedWidth * 0.58,
            color: CustomColors.purple,
          ),
        ),
      ),
    );
  }
