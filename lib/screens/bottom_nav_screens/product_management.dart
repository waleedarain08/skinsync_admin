import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/product_dailogboxs.dart';

class ProductManagement extends StatefulWidget {
  static const String routeName = '/product-management';
  const ProductManagement({super.key});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildInventoryOverview(),
            SizedBox(height: 32.h),
            _buildFilters(),
            SizedBox(height: 24.h),
            _buildProductsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Inventory & Products", style: CustomFonts.black32w700),
            SizedBox(height: 8.h),
            Text(
              "Manage retail products and professional supplies across all clinics.",
              style: CustomFonts.grey14w400,
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ProductDialogBox(),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('Add New Product', style: CustomFonts.white14w500),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.black,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryOverview() {
    return Row(
      children: [
        _buildInventoryStat("Total SKU", "124", Icons.inventory_2_outlined, CustomColors.amber),
        SizedBox(width: 16.w),
        _buildInventoryStat("Low Stock Items", "12", Icons.warning_amber_rounded, CustomColors.red),
        SizedBox(width: 16.w),
        _buildInventoryStat("Total Stock Value", "\$84,200", Icons.monetization_on_outlined, CustomColors.green),
        SizedBox(width: 16.w),
        _buildInventoryStat("Categories", "8", Icons.category_outlined, CustomColors.black),
      ],
    );
  }

  Widget _buildInventoryStat(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: CustomFonts.black20w600),
                Text(title, style: CustomFonts.grey12w400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CupertinoSearchTextField(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              placeholder: "Search products by name, SKU or brand...",
              backgroundColor: CustomColors.whiteGrey,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: 16.w),
          _filterDropdown("Category", "All Categories"),
          SizedBox(width: 12.w),
          _filterDropdown("Status", "In Stock"),
        ],
      ),
    );
  }

  Widget _filterDropdown(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.lightGrey),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Text("$label: ", style: CustomFonts.white13w500),
          Text(value, style: CustomFonts.black13w600),
          Icon(Icons.keyboard_arrow_down, size: 18.sp),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.75,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => _buildProductCard(index),
    );
  }

  Widget _buildProductCard(int index) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                image: const DecorationImage(
                  image: NetworkImage("https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SKU-9283${index}", style: CustomFonts.amber10w800ls1),
                SizedBox(height: 4.h),
                Text("Advanced Night Repair", style: CustomFonts.black16w600, maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 4.h),
                Text("Skincare • 50ml", style: CustomFonts.white12w400),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Stock", style: CustomFonts.white10w600),
                        Text("45 Units", style: CustomFonts.black14w600),
                      ],
                    ),
                    _stockBadge(index == 1 ? "Low Stock" : "In Stock"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stockBadge(String status) {
    final bool isLow = status == "Low Stock";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isLow ? CustomColors.red.withValues(alpha: 0.1) : CustomColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        status,
        style: isLow ? CustomFonts.red10w600 : CustomFonts.green10w600,
      ),
    );
  }
}
