import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/product_dailogboxs.dart';
import 'package:skinsync_admin/widgets/patient_management_mini_tile_widget.dart';
import 'package:skinsync_admin/widgets/product_tile.dart';
import 'package:skinsync_admin/widgets/revenue_trend_widget.dart';

import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_dropdown_widget.dart';
import '../../widgets/dailogbox/clinic_dailogbox.dart';
import '../../widgets/empty_widget.dart';

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
      ref.read(productViewModelProvider.notifier).initialize();
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
  double childAspectRatio = context.isLandscape ? 1.1 : 1.2;

  return Consumer(
    builder: (context, ref, child) {
      final state = ref.watch(productViewModelProvider);

      if (state.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.products == null || state.products!.isEmpty) {
        return EmptyWidget(text: "No products available.");
      } else {
        return GridView.builder(
          itemCount: state.products?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20.w,
            mainAxisSpacing: 20.h,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            return ProductTile(product: state.products![index]);
          },
        );
      }
    },
  );
}
