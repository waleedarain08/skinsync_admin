import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/widgets/custom_cashed_image_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/product_dailogboxs.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/product_view_model.dart';

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProductDialogBox(product: product),
        );
      },
      onDoubleTap: () {
        ref.read(productViewModelProvider.notifier).deleteProduct(product.id!);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: CustomColors.lightBlueColor.withValues(alpha: 0.2),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
            BoxShadow(
              color: CustomColors.lightPurpleColor.withValues(alpha: 0.1),
              blurRadius: 10.r,
              offset: Offset(2.h, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
                child: Stack(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomCachedImage(
                        width: double.infinity,
                        imageUrl: product.image,
                      ),
                    ),
                    // Positioned(
                    //   top: 10.h,
                    //   right: 10.w,
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 8.w,
                    //       vertical: 4.h,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white.withValues(alpha: 0.9),
                    //       borderRadius: BorderRadius.circular(20.r),
                    //     ),
                    //     child: Text(
                    //       'Units: ${item.units}',
                    //       style: CustomFonts.black12w600.copyWith(
                    //         color: item.quantity < 20 ? Colors.red : Colors.green,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: CustomFonts.black16w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'units: ${product.unit}',
                      style: CustomFonts.black14w600.copyWith(
                        color: CustomColors.purpleColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: Text(
                        product.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: CustomFonts.black13w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
