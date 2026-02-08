import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/patient_management_mini_tile_widget.dart';
import 'package:skinsync_admin/widgets/revenue_trend_widget.dart';

import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/responsive.dart';
import '../../widgets/comming_soon_widget.dart';
import '../../widgets/custom_dropdown_widget.dart';

class ClinicManagement extends StatelessWidget {
  static const String routeName = '/clinic-management';
  const ClinicManagement({super.key});

  List<ClientManamentMiniTileModel> get tiles => [
    ClientManamentMiniTileModel(
      title: "Total Clinics",
      subTitle: "48",
      icon: Icons.business,
      iconBgColor: Colors.blueAccent,
    ),
    ClientManamentMiniTileModel(
      title: "Active Clinic",
      subTitle: "1,250",
      icon: Icons.stacked_line_chart_rounded,
      iconBgColor: Colors.green,
    ),
    ClientManamentMiniTileModel(
      title: "Total Revenue",
      subTitle: "\$2458K",
      icon: Icons.monetization_on_outlined,
      iconBgColor: Colors.purple,
    ),
    ClientManamentMiniTileModel(
      title: "Avg Rating",
      subTitle: "4.7",
      icon: Icons.star_border_outlined,
      iconBgColor: Colors.amber,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Text("Patient Management", style: CustomFonts.black30w600),
            SizedBox(height: 10.h),
            Text(
              "Analyze patient data, treatment trends, and engagement metrics across all clinics",
              style: CustomFonts.grey18w400,
            ),
            SizedBox(height: 20.h),
            Divider(color: CustomColors.greyColor),
            SizedBox(height: 50.h),
            _buildStatsTile(),

            RevenueTrendWidget(),
            BorderdContainerWidget(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CupertinoSearchTextField(
                      backgroundColor: Color(0xFFF3F3F5),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: CustomDropdown(
                      hint: "All Regions",
                      value: "All Regions",
                      items: [
                        "All Regions",
                        "Region 1",
                        "Region 2",
                        "Region 3",
                      ],
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            RegisteredClinicsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTile() {
    return AdaptiveLayoutRowColumn(
      expandedWidget: true,
      children: List.generate(
        4,
        (index) => PatientManagementMiniTileWidget(data: tiles[index]),
      ),
    );
  }
}

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

class RegisteredClinicsTable extends StatelessWidget {
  const RegisteredClinicsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text("Registered Clinics", style: CustomFonts.black20w600),
          SizedBox(height: 20.h),

          // Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Color(0xFFF3F3F5)),

              border: TableBorder(
                borderRadius: BorderRadius.circular(10),
                horizontalInside: BorderSide(
                  color: Color(0xFFF3F3F5),
                  width: 1,
                ),
                right: BorderSide(color: Color(0xFFF3F3F5), width: 1),
                left: BorderSide(color: Color(0xFFF3F3F5), width: 1),
                verticalInside: BorderSide(color: Color(0xFFF3F3F5), width: 1),
              ),
              headingRowHeight: 50.h,
              dataRowHeight: 50.h,
              headingTextStyle: CustomFonts.black16w600,
              columns: const [
                DataColumn(label: Text('Business Name')),
                DataColumn(label: Text('Location')),
                DataColumn(label: Text('Active Users')),
                DataColumn(label: Text('Appointments')),
                DataColumn(label: Text('Revenue')),
                DataColumn(label: Text('Rating')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: List.generate(
                5,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        'Radiant Skin Clinic',
                        style: CustomFonts.black14w400,
                      ),
                    ),
                    DataCell(
                      Text(
                        'Los Angeles, California',
                        style: CustomFonts.black14w400,
                      ),
                    ),
                    DataCell(Text('320', style: CustomFonts.black14w400)),
                    DataCell(Text('1250', style: CustomFonts.black14w400)),
                    DataCell(Text('\$125,000', style: CustomFonts.black14w400)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text('4.8', style: CustomFonts.black14w400),
                        ],
                      ),
                    ),

                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.blackColor,
                          borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        ),
                        child: Text('Active', style: CustomFonts.white16w400),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            color: CustomColors.blackColor,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text('View', style: CustomFonts.black14w500),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
