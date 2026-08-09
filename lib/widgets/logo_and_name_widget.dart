
import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';

class LogoAndNameWidget extends StatelessWidget {
  final String profileName;
  final String profileLogo;

  const LogoAndNameWidget({
    super.key,
    required this.profileName,
    required this.profileLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: CustomColors.purple,
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: profileLogo.isNotEmpty
                ? AppNetworkImage(
                    imageUrl: profileLogo,
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    PngAssets.splashLogo,
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        context.horizontalSpace(10),
        Text(
          profileName.isNotEmpty ? profileName : 'N/A',
          style: context.fonts.black16w600,
        ),
      ],
    );
  }
}
