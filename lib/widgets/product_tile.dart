import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/models/product_model.dart';
import '../models/treatment_model.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/responsive.dart';

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // height: context.isLandscape ? 300.h : 500.h,
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
        alignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              PngAssets.image,
              // width: 0.5.sw,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Color(0xFFE8E8E8),
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(product.name ?? "N/A", style: CustomFonts.black18w600),
              SizedBox(height: 20.h),

              // Area
              Text(
                " Units: ${product.units ?? ""}",
                style: CustomFonts.black18w600.copyWith(
                  color: CustomColors.purpleColor,
                ),
              ),
            ],
          ),

          // Icon(Icons.edit),
        ],
      ),
    );
  }
}
