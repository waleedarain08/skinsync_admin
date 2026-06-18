import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/widgets/custom_cashed_image_widget.dart';
import 'package:skinsync_admin/screens/create_product_screen.dart';
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
        context.push(CreateProductScreen.routeName, extra: product);
      },
      onDoubleTap: () {
        ref.read(productViewModelProvider.notifier).deleteProduct(product.id!);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: CustomColors.purple.withValues(alpha: 0.2),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
            BoxShadow(
              color: CustomColors.purple.withValues(alpha: 0.1),
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
                    CustomCachedImage(
                      width: double.infinity,
                      imageUrl: product.image,
                    ),
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
                      style: context.fonts.black16w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'units: ${product.unit}',
                      style: context.fonts.purple14w600,
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: Text(
                        product.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: context.fonts.black13w400,
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
