import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/clinic_management.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

class PatientManagementMiniTileWidget extends StatelessWidget {
  const PatientManagementMiniTileWidget({super.key, required this.data});

  final ClientManamentMiniTileModel data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BorderdContainerWidget(
        borderRadius: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(data.title, style: CustomFonts.black16w600),
                Text(data.subTitle, style: CustomFonts.black20w600),
              ],
            ),
            // SizedBox(width: 20.w),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: data.iconBgColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(data.icon, color: data.iconBgColor),
            ),
          ],
        ),
      ),
    );
  }
}
