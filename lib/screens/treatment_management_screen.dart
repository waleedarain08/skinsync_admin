import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/screens/create_treatment_screen.dart';
import '../../utils/responsive.dart';
import '../../view_models/treatment_view_model.dart';
import '../utils/custom_fonts.dart';
import '../utils/extentions.dart';
import '../widgets/empty_widget.dart';
import '../widgets/treatment_list_tile.dart';

class TreatmentManagementScreen extends ConsumerStatefulWidget {
  const TreatmentManagementScreen({super.key});

  static const String routeName = '/treatment-management';

  @override
  ConsumerState<TreatmentManagementScreen> createState() =>
      _TreatmentManagementScreenState();
}

class _TreatmentManagementScreenState
    extends ConsumerState<TreatmentManagementScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 20.h),
            Row(
              children: [
                Text("Treatments", style: CustomFonts.black22w600),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.push(CreateTreatmentScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
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
                      Text('Create Treatment', style: CustomFonts.white14w500),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 50.h),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(treatmentViewModelProvider);

                  if (state.loading) {
                    return ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (_, __) => SizedBox(height: 20.h),
                      itemBuilder: (context, index) {
                        return Container(
                          height: context.isLandscape ? 300.h : 100.h,
                          margin: EdgeInsets.all(20.w),
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        );
                      },
                    ).withShimmer();
                  } else if (state.treatments.isEmpty) {
                    return EmptyWidget();
                  }

                  return ListView.separated(
                    itemCount: 4,
                    // itemCount: state.treatments.length,
                    separatorBuilder: (_, __) => SizedBox(height: 20.h),
                    itemBuilder: (context, index) {
                      return TreatmentListTile(
                        treatment: TreatmentModel(
                          id: 1,
                          name: 'Treatment 1',
                          description: 'Description 1',
                          isArea: false,
                          price: 100,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
