import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TopTreatmentsChart extends StatelessWidget {
  TopTreatmentsChart({super.key});

  final List<TreatmentData> chartData = [
    TreatmentData('Botox', 340),
    TreatmentData('Facial', 280),
    TreatmentData('Laser Treatment', 220),
    TreatmentData('Microneedling', 180),
    TreatmentData('Chemical Peel', 165),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 255.h,

      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelStyle: context.fonts.grey14w400,
        ),
        primaryYAxis: const NumericAxis(
          minimum: 0,
          maximum: 340,
          interval: 85,
          majorGridLines: MajorGridLines(dashArray: [5, 5]),
        ),
        series: [
          ColumnSeries<TreatmentData, String>(
            dataSource: chartData,
            xValueMapper: (TreatmentData data, _) => data.treatment,
            yValueMapper: (TreatmentData data, _) => data.volume,
            width: 0.6,
            color: const Color(0xFF4F46E5), // Indigo/blue like screenshot
          ),
        ],
      ),
    );
  }
}

class TreatmentData {
  final String treatment;
  final double volume;

  TreatmentData(this.treatment, this.volume);
}
