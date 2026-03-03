import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/treatment_model.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/responsive.dart';
import '../view_models/treatment_view_model.dart';
import 'dailogbox/edit_treatment_dailogbox.dart';

class TreatmentListTile extends ConsumerWidget {
  const TreatmentListTile({super.key, required this.treatment});

  final TreatmentModel treatment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: context.isLandscape ? 300.h : 500.h,
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: CustomColors.lightBlueColor,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
          BoxShadow(
            color: CustomColors.lightPurpleColor,
            blurRadius: 10.r,
            offset: Offset(2.h, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: AdaptiveLayoutRowColumn(
        size: MainAxisSize.max,
        expandedWidget: true,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              PngAssets.image,
              // width: 0.5.sw,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Color(0xFFE8E8E8),
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          context.isLandscape
              ? treatmentResponsiveData(context, ref)
              : Expanded(child: treatmentResponsiveData(context, ref)),

          // Icon(Icons.edit),
        ],
      ),
    );
  }

  Widget treatmentResponsiveData(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentGeometry.centerRight,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  // ref
                  //     .read(treatmentViewModelProvider.notifier)
                  //     .setTreatment(treatment.id!);
                  showDialog(
                    context: context,
                    builder: (context) => const EditTreatmentDialog(),
                  );
                },
                child: Icon(Icons.edit),
              ),
              InkWell(
                onTap: () {
                  // ref
                  //     .read(treatmentViewModelProvider.notifier)
                  //     .deleteTreatment(treatmentId: treatment.id!);
                },
                child: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),

        // Title
        Text(treatment.name ?? "N/A", style: CustomFonts.black18w600),
        SizedBox(height: 20.h),
        // Area
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.w),
            child: Wrap(
              spacing: 20.r,
              runSpacing: 20.r,
              children: List.generate(
                treatment.sideAreas?.length ?? 0,
                (index) => Container(
                  margin: EdgeInsets.only(right: 10.w),
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.lightBlueColor,
                        blurRadius: 8.r,
                        offset: Offset(0, 2.h),
                      ),
                      BoxShadow(
                        color: CustomColors.lightPurpleColor,
                        blurRadius: 10.r,
                        offset: Offset(2.h, 0),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        treatment.sideAreas?[index].name ?? "N/A",
                        style: CustomFonts.black14w500.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Price
                      treatment.sideAreas?[index].perSyringePrice == null
                          ? SizedBox()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style:
                                        CustomFonts.black14w600, // base style
                                    children: [
                                      TextSpan(
                                        text:
                                            "\$${treatment.sideAreas?[index].perSyringePrice ?? ""} ",
                                        style: CustomFonts.black14w600.copyWith(
                                          color: CustomColors.blueColor,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: " /Per Syringe",
                                        // inherits font from parent; add color here if you want a different one
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            " Price: \$${treatment.price ?? ""}",
            style: CustomFonts.black18w600.copyWith(
              color: CustomColors.purpleColor,
            ),
          ),
        ),
      ],
    );
  }
}
