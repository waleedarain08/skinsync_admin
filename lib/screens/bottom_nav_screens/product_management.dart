import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/models/product_model.dart';
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
import '../../widgets/dailogbox/register_clinic_dailogbox.dart';

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
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ProductTile(
                  product: ProductModel(name: "product", units: 2),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
