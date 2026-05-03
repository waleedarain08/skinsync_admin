import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/utils/responsive.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
import 'package:skinsync_admin/widgets/patient_mangement_graph.dart';

class PatientManagement extends StatefulWidget {
  static const String routeName = '/patient-management';
  const PatientManagement({super.key});

  @override
  State<PatientManagement> createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> {
  String? selectedClinic;
  String? selectedDateRange;
  String? selectedTreatment;

  final List<String> clinicItems = [
    "All Clinics",
    "SkinSync Clinic ",
    "SkinSync Clinic ",
    "SkinSync Clinic ",
  ];

  final List<String> dateRangeItems = [
    "Today",
    "Last 7 Days",
    "Last 30 Days",
    "This Month",
    "Custom Range",
  ];

  final List<String> treatmentItems = [
    "All Treatments",
    "Laser Therapy",
    "Facial Treatment",
    "Skin Consultation",
    "Acne Treatment",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
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
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: CustomColors.greyColor),
                ),
                child: _buildFiltersDropDown(),
              ),
              SizedBox(height: 20.h),
              _buildPatientsTile(),

              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: CustomColors.greyColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top Treatments by Volume",
                      style: CustomFonts.black20w600,
                    ),
                    SizedBox(height: 17.h),
                    TopTreatmentsChart(),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(child: buildProgressContainer()),
                  SizedBox(width: 20.w),
                  Expanded(child: buildPatientDemographics()),
                ],
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgressContainer() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: CustomColors.greyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Common Skin Concerns", style: CustomFonts.black20w600),
          SizedBox(height: 21.h),
          buildProgressBar(title: "Fine lines", progress: "85", value: 0.85),
          SizedBox(height: 16.h),
          buildProgressBar(title: "Acne scars", progress: "75", value: 0.75),
          SizedBox(height: 16.h),
          buildProgressBar(title: "Pigmentation", progress: "65", value: 0.65),
          SizedBox(height: 16.h),
          buildProgressBar(title: "Dry skin", progress: "55", value: 0.55),
          SizedBox(height: 16.h),
          buildProgressBar(title: "Large pores", progress: "45", value: 0.45),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget buildPatientDemographics() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: CustomColors.greyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Patient Demographics", style: CustomFonts.black20w600),
          SizedBox(height: 21.h),
          Text("Age Distribution", style: CustomFonts.black16w400),

          SizedBox(height: 7.h),
          buildTextRowOfProgess(title: '18-30 years', progress: '28'),
          SizedBox(height: 7.h),
          buildTextRowOfProgess(title: '31-45 years', progress: '42'),
          SizedBox(height: 7.h),
          buildTextRowOfProgess(title: '46-60 years', progress: '22'),
          SizedBox(height: 7.h),
          buildTextRowOfProgess(title: '60+ years', progress: '8'),
          SizedBox(height: 16.h),
          Divider(color: CustomColors.greyColor),
          SizedBox(height: 16.h),
          Text("Gender Distribution", style: CustomFonts.black16w400),

          SizedBox(height: 7.h),
          buildTextRowOfProgess(title: 'Female', progress: '72'),

          SizedBox(height: 7.h),
          buildTextRowOfProgess(title: 'Male', progress: '26'),

          SizedBox(height: 7.h),
          buildTextRowOfProgess(title: 'Others', progress: '2'),
        ],
      ),
    );
  }

  Widget buildTextRowOfProgess({
    required String title,
    required String progress,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: CustomFonts.black16w400),
        Text("$progress%", style: CustomFonts.black16w400),
      ],
    );
  }

  Widget buildProgressBar({
    required String title,
    required String progress,
    required double value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: CustomFonts.black16w400),
            Text("$progress%", style: CustomFonts.black16w400),
          ],
        ),
        SizedBox(height: 20.h),
        LinearProgressIndicator(
          value: value,
          color: CustomColors.drakPurpleColor,
          minHeight: 8.h,
          borderRadius: BorderRadius.circular(20.r),
          backgroundColor: CustomColors.greyColor,
        ),
      ],
    );
  }

  Widget _buildFiltersDropDown() {
    return AdaptiveLayoutRowColumn(
      expandedWidget: true,
      children: [
        // Clinic Dropdown
        buildDropdown(
          label: "Filter by Clinic",
          value: selectedClinic,
          items: clinicItems,
          onChanged: (v) => setState(() => selectedClinic = v),
        ),
        SizedBox(width: 15.w),

        // Date Range Dropdown
        buildDropdown(
          label: "Date Range",
          value: selectedDateRange,
          items: dateRangeItems,
          onChanged: (v) => setState(() => selectedDateRange = v),
        ),
        SizedBox(width: 15.w),

        // Treatment Dropdown
        buildDropdown(
          label: "Treatment Type",
          value: selectedTreatment,
          items: treatmentItems,
          onChanged: (v) => setState(() => selectedTreatment = v),
        ),
      ],
    );
  }

  /// Reusable dropdown builder
  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.black20w600),
        SizedBox(height: 15.h),
        CustomDropdown(
          hint: label,
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

Widget _buildPatientsTile() {
  return AdaptiveLayoutRowColumn(
    expandedWidget: true,
    children: List.generate(
      4,
      (index) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: CustomColors.greyColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Patients", style: CustomFonts.black16w600),
                  SizedBox(height: 5.h),
                  Text("1,247", style: CustomFonts.black16w600),
                  SizedBox(height: 10.h),
                  Text(
                    "+12.5% from last period",
                    overflow: TextOverflow.ellipsis,
                    style: CustomFonts.green16w400,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: CustomColors.drakPurpleColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.people_alt_outlined,
                size: 24.sp,
                color: CustomColors.drakPurpleColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
