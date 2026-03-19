import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/add_products_dailogbox.dart';
import 'package:skinsync_admin/widgets/patient_management_mini_tile_widget.dart';
import 'package:skinsync_admin/widgets/product_tile.dart';
import 'package:skinsync_admin/widgets/revenue_trend_widget.dart';

import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_dropdown_widget.dart';
import '../../widgets/dailogbox/clinic_dailogbox.dart';

class ProductManagement extends ConsumerStatefulWidget {
  static const String routeName = '/product-management';
  const ProductManagement({super.key});

  @override
  ConsumerState<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends ConsumerState<ProductManagement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(productViewModelProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          Row(
            children: [
              Text("Product Management", style: CustomFonts.black30w600),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Handle create staff
                  // ref
                  //     .read(treatmentViewModelProvider.notifier)
                  //     .getTreatments();
                  // context.push(AddTreatmentScreen.routeName);
                  showDialog(
                    context: context,
                    builder: (context) => const AddProductsDailogbox(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  children: [
                    Center(
                      child: Icon(Icons.add, color: Colors.white, size: 20.r),
                    ),
                    SizedBox(width: 10.w),
                    Text('Add Product', style: CustomFonts.white14w500),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text("Analyze products data", style: CustomFonts.grey18w400),
          SizedBox(height: 20.h),
          Divider(color: CustomColors.greyColor),
          Expanded(child: _buildInventoryGrid(context)),
        ],
      ),
    );
  }
}

Widget _buildInventoryGrid(BuildContext context) {
  int crossAxisCount = context.isLandscape ? 4 : 2;
  double childAspectRatio = context.isLandscape ? 1.1 : 0.7;

  return GridView.builder(
    itemCount: 40,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 20.h,
      childAspectRatio: childAspectRatio,
    ),
    itemBuilder: (context, index) {
      return _buildInventoryCard(ProductModel(name: "Nicinamide", units: 10));
    },
  );
}

Widget _buildInventoryCard(ProductModel item) {
  return Container(
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
                Image.asset(
                  PngAssets.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE8E8E8),
                    child: const Icon(Icons.broken_image, color: Colors.grey),
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
        Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name ?? "N/A",
                style: CustomFonts.black16w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Text(
                'units: ${item.units}',
                style: CustomFonts.black14w600.copyWith(
                  color: CustomColors.purpleColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: CustomFonts.black13w400,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
