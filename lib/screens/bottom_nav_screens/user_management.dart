import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';

class UserManagement extends StatelessWidget {
  static const String routeName = '/user-management';
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Text("User Management", style: CustomFonts.black30w600),
              SizedBox(height: 10.h),
              Text(
                "Manage all registered users including patients and clinics",
                style: CustomFonts.grey18w400,
              ),
              SizedBox(height: 20.h),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 50.h),
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    CupertinoSearchTextField(
                      backgroundColor: Color(0xFFF3F3F5),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      padding: EdgeInsets.all(5.w),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 7.w,
                              horizontal: 50.w,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Text(
                              "Patients",
                              style: CustomFonts.black16w600,
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 7.w,
                              horizontal: 50.w,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Text(
                              "Clinics",
                              style: CustomFonts.black16w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    UserDataTable(),
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

class UserDataTable extends StatelessWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  Colors.grey.shade100,
                ),
                headingRowHeight: 50.h,
                dataRowHeight: 60.h,
                columnSpacing: 40.w,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  verticalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                columns: [
                  DataColumn(
                    label: Text('Name', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    label: Text('Email', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    label: Text('Mobile', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    label: Text('State', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    label: Text('Status', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    label: Text('Actions', style: CustomFonts.black16w600),
                  ),
                ],
                rows: [
                  _buildDataRow(
                    'Emma Johnson',
                    'emma.johnson@email.com',
                    '+1 (555) 123-4567',
                    'California',
                    true,
                    true,
                  ),
                  _buildDataRow(
                    'Michael Chen',
                    'emma.johnson@email.com',
                    '+1 (555) 234-5678',
                    'New York',
                    true,
                    false,
                  ),
                  _buildDataRow(
                    'Sarah Williams',
                    'sarah.williams@email.com',
                    '+1 (555) 345-6789',
                    'Texas',
                    false,
                    false,
                  ),
                  _buildDataRow(
                    'David Martinez',
                    'david.martinez@email.com',
                    '+1 (555) 456-7890',
                    'Florida',
                    true,
                    false,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  DataRow _buildDataRow(
    String name,
    String email,
    String mobile,
    String state,
    bool isActive,
    bool showActions,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(name, style: CustomFonts.black14w400)),
        DataCell(Text(email, style: CustomFonts.black14w400)),
        DataCell(Text(mobile, style: CustomFonts.black14w400)),
        DataCell(Text(state, style: CustomFonts.black14w400)),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isActive ? Colors.black : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Degular',
              ),
            ),
          ),
        ),
        DataCell(
          PopupMenuButton(
            padding: EdgeInsetsGeometry.all(0),

            borderRadius: BorderRadius.circular(15.r),
            color: Colors.white,

            icon: Icon(Icons.more_vert, size: 20.sp),

            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,

                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 16.sp, color: Colors.black),
                      SizedBox(width: 10.w),
                      Text("View Details", style: CustomFonts.black14w400),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_remove,
                        size: 16.sp,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10.w),
                      Text("Deactivate", style: CustomFonts.black14w400),
                    ],
                  ),
                ),
              ),
              // PopupMenuItem(value: 3, child: Text('Export', style: TextStyle(fontSize: 14.sp))),
            ],
          ),
        ),
      ],
    );
  }
}
