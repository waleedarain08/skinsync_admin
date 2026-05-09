import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/create_treatment_screen.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

class TreatmentManagementScreen extends StatefulWidget {
  const TreatmentManagementScreen({super.key});
  static const String routeName = '/treatment-management';

  @override
  State<TreatmentManagementScreen> createState() => _TreatmentManagementScreenState();
}

class _TreatmentManagementScreenState extends State<TreatmentManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _categories = ["AESTHETICS", "FACE", "BODY"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildCategoryTabs(),
            SizedBox(height: 24.h),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((cat) => _buildCategoryView(cat)).toList(),
              ),
            ),
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
            Text("Treatment Master List", style: CustomFonts.textMain32w700),
            SizedBox(height: 8.h),
            Text(
              "Define master treatments and hierarchical structures for all clinics.",
              style: CustomFonts.textMain14w400.copyWith(color: CustomColors.textMuted),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => context.push(CreateTreatmentScreen.routeName),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('Create Master Treatment', style: CustomFonts.white14w500),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.deepNavy,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.luxuryWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: CustomColors.greyColor),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: CustomColors.primaryGold,
        labelColor: CustomColors.primaryGold,
        unselectedLabelColor: CustomColors.textLight,
        labelStyle: CustomFonts.black16w600.copyWith(fontSize: 14.sp),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: _categories.map((cat) => Tab(text: cat)).toList(),
      ),
    );
  }

  Widget _buildCategoryView(String category) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildSubCategorySidebar(category),
        ),
        SizedBox(width: 24.w),
        Expanded(
          flex: 3,
          child: _buildTreatmentGrid(category),
        ),
      ],
    );
  }

  Widget _buildSubCategorySidebar(String category) {
    List<String> subCats = [];
    if (category == "AESTHETICS") subCats = ["Injectables", "Skin Treatments", "Laser & Energy"];
    if (category == "FACE") subCats = ["Upper Face", "Mid Face", "Lower Face", "Neck"];
    if (category == "BODY") subCats = ["Abdomen", "Arms", "Thighs", "Flanks"];

    return BorderdContainerWidget(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Text("Sub-Categories", style: CustomFonts.textMain16w600.copyWith(color: CustomColors.textMuted)),
          ),
          ...subCats.map((sub) => _buildSubCatItem(sub, sub == subCats[0])).toList(),
          const Spacer(),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add Sub-Cat"),
              style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 45.h)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCatItem(String title, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isSelected ? CustomColors.primaryGold.withOpacity(0.05) : Colors.transparent,
        border: Border(left: BorderSide(color: isSelected ? CustomColors.primaryGold : Colors.transparent, width: 4)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? CustomColors.primaryGold : CustomColors.textDark,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildTreatmentGrid(String category) {
    return Column(
      children: [
        BorderdContainerWidget(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              const Icon(Icons.search, color: CustomColors.textLight),
              SizedBox(width: 12.w),
              const Expanded(child: TextField(decoration: InputDecoration(hintText: "Search treatments...", border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none))),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.85,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => _buildTreatmentCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentCard(int index) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              color: CustomColors.softChampagne,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              image: const DecorationImage(image: NetworkImage("https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?q=80&w=1000&auto=format&fit=crop"), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(color: CustomColors.primaryGold.withOpacity(0.1), borderRadius: BorderRadius.circular(4.r)),
                      child: Text("Injectable", style: TextStyle(color: CustomColors.primaryGold, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                    ),
                    const Icon(Icons.more_horiz, size: 18),
                  ],
                ),
                SizedBox(height: 12.h),
                Text("Neurotoxins (Botox)", style: CustomFonts.black16w600),
                SizedBox(height: 4.h),
                Text("Forehead, Crow's Feet, Glabella", style: CustomFonts.grey18w400.copyWith(fontSize: 12.sp), maxLines: 2, overflow: TextOverflow.ellipsis),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("3 Clinics", style: TextStyle(color: CustomColors.textLight, fontSize: 11.sp)),
                    Text("Active", style: TextStyle(color: CustomColors.successGreen, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
