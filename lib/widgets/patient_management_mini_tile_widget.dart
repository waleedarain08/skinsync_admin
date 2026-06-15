import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

class ClientManamentMiniTileModel {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color iconBgColor;

  ClientManamentMiniTileModel({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.iconBgColor,
  });
}

class PatientManagementMiniTileWidget extends StatelessWidget {
  const PatientManagementMiniTileWidget({super.key, required this.data});

  final ClientManamentMiniTileModel data;

  @override
  Widget build(BuildContext context) {
    return BorderdContainerWidget(
      borderRadius: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(data.title, style: context.fonts.black16w600),
              Text(data.subTitle, style: context.fonts.black20w600),
            ],
          ),
          // SizedBox(width: 20.w),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: data.iconBgColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(data.icon, color: data.iconBgColor),
          ),
        ],
      ),
    );
  }
}
