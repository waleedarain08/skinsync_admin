import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_admin/utils/assets.dart';

import '../widgets/dailogbox/payment_dailog_box.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F5),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Payment Management',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Manage financial transactions and release payments to clinics',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 16.h),
            const Divider(),
            SizedBox(height: 24.h),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Pending Payments',
                    count: '\$620',
                    subtitle: "2 transactions",
                    icon: Iconsax.clock,
                    color: const Color(0xFFFF4C4C),
                    bgColor: const Color(0xFFFFF0F0),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildStatCard(
                    title: 'Pending',
                    count: '10',
                    subtitle: "2 transactions",
                    icon: Iconsax.tick_circle,
                    color: const Color(0xFFFDB528),
                    bgColor: const Color(0xFFFFF8E5),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildStatCard(
                    title: 'Resolved',
                    count: '5',
                    icon: Iconsax.card,
                    color: const Color(0xFF155DFC),
                    bgColor: const Color(0xFFE8FAF0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // Pending Disputes Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                  ),
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Pending Payment Releases',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.sp,
                          height: 0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1.w,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.clock,
                              size: 16.sp,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              '2 Pending',
                              style: TextStyle(
                                fontSize: 16.sp,
                                height: 0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildDisputesTable(
                    isPending: true,
                    rows: [
                      const DataRow2(
                        cells: [
                          const DataCell(Text('TXN-2025-10-001')),
                          const DataCell(Text('Sarah Williams')),
                          const DataCell(Text('Radiant Skin Clinic')),
                          const DataCell(Text('Botox Treatment')),
                          const DataCell(Text('\$180')),
                          const DataCell(Text('10/25/2025')),
                          const DataCell(Text('Credit Card')),
                          DataCell(
                            _StatusBadge(
                              text: 'Release Payment',
                              image: SvgAssets.money,
                            ),
                          ),
                        ],
                      ),
                      const DataRow2(
                        cells: [
                          const DataCell(Text('TXN-2025-10-001')),
                          const DataCell(Text('Sarah Williams')),
                          const DataCell(Text('Radiant Skin Clinic')),
                          const DataCell(Text('Botox Treatment')),
                          const DataCell(Text('\$180')),
                          const DataCell(Text('10/25/2025')),
                          const DataCell(Text('Cash')),
                          DataCell(
                            _StatusBadge(
                              text: 'Release Payment',
                              image: SvgAssets.money,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Resolved Disputes Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                  ),
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Recently Released Payments',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildResolvedTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    String? subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                count,
                style: TextStyle(
                  fontSize: 20.sp,
                  height: 0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5.h),

              Text(
                subtitle ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: bgColor, //bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputesTable({
    required bool isPending,
    required List<DataRow> rows,
  }) {
    // Calculate height based on rows: Heading(56) + Rows * 60 + Padding(32) + BorderCorrection(2)
    // Using 60 as a comfortable row height
    double rowHeight = 60.h;
    double headingHeight = 56.h;
    double totalHeight = headingHeight + (rows.length * rowHeight) + 35.h;

    return Container(
      height: totalHeight,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12.r),
      //   // Remove container border if DataTable handles it, or keep for outer rounding if TableBorder is rectangular
      //   border: Border.all(color: Colors.grey.withOpacity(0.2)),
      // ),
      // padding: EdgeInsets.all(16.w),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 900, // Ensure horizontal scrolling on small screens
        dataRowHeight: rowHeight,
        headingRowHeight: headingHeight,
        headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 14.sp,
        ),
        // Add Grid Borders
        border: TableBorder(
          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
          left: BorderSide(color: Colors.grey.withOpacity(0.2)),
          right: BorderSide(color: Colors.grey.withOpacity(0.2)),
          verticalInside: BorderSide(color: Colors.grey.withOpacity(0.2)),
          horizontalInside: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        columns: const [
          DataColumn2(label: Text('Transaction ID'), size: ColumnSize.L),
          DataColumn2(label: Text('Patient'), size: ColumnSize.L),
          DataColumn2(label: Text('Clinic'), size: ColumnSize.L),
          DataColumn2(label: Text('Service'), size: ColumnSize.L),
          DataColumn2(label: Text('Amount'), size: ColumnSize.M),
          DataColumn2(label: Text('Date'), size: ColumnSize.M),
          DataColumn2(label: Text('Payment Method'), size: ColumnSize.M),
          DataColumn2(label: Text('Actions'), size: ColumnSize.M),
        ],
        rows: rows,
      ),
    );
  }

  Widget _buildResolvedTable() {
    // Defines rows locally for now or passed in.
    // Since the original code had hardcoded rows inside the widget, we'll keep it correct.
    // We need to extract the rows to a list to count them properly for height calculation.

    List<DataRow> rows = [
      DataRow2(
        cells: [
          const DataCell(Text('TXN-2025-10-001')),
          const DataCell(Text('Sarah Williams')),
          const DataCell(Text('Radiant Skin Clinic')),
          const DataCell(Text('Botox Treatment')),
          const DataCell(Text('\$180')),
          const DataCell(Text('10/25/2025')),
          const DataCell(Text('Credit Card')),
          DataCell(_StatusBadge(text: 'Released', image: SvgAssets.circleTick)),
        ],
      ),
    ];

    double rowHeight = 60.h;
    double headingHeight = 56.h;
    double totalHeight = headingHeight + (rows.length * rowHeight) + 35.h;

    return Container(
      height: totalHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      // padding: EdgeInsets.all(16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 800,
          dataRowHeight: rowHeight,
          headingRowHeight: headingHeight,
          headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 14.sp,
          ),
          border: TableBorder(
            // top: BorderSide(color: Colors.grey.withOpacity(0.2)),
            //bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            // left: BorderSide(color: Colors.grey.withOpacity(0.2)),
            // right: BorderSide(color: Colors.grey.withOpacity(0.2)),
            verticalInside: BorderSide(color: Colors.grey.withOpacity(0.2)),
            horizontalInside: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          columns: const [
            DataColumn2(label: Text('Transaction ID'), size: ColumnSize.L),
            DataColumn2(label: Text('Patient'), size: ColumnSize.L),
            DataColumn2(label: Text('Clinic'), size: ColumnSize.L),
            DataColumn2(label: Text('Service'), size: ColumnSize.L),
            DataColumn2(label: Text('Amount'), size: ColumnSize.M),
            DataColumn2(label: Text('Date'), size: ColumnSize.M),
            DataColumn2(label: Text('Payment Method'), size: ColumnSize.M),
            DataColumn2(label: Text('Actions'), size: ColumnSize.S),
          ],
          rows: rows,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final String image;
  const _StatusBadge({required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (context) => ReleasePaymentDialog(
            transactionId: "TXN-2025-10-001",
            patientName: "Emma Johnson",
            clinicName: "Radiant Skin Clinic",
            serviceName: "Botox Treatment",
            amount: "\$450",
            feedbackMessage:
                "The treatment was rushed and did not meet the promised duration. I felt the service quality was below expectations.",
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Color(0xFF00A63E),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(image),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
