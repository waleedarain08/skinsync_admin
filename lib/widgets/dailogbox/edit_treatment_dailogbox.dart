import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../models/requests/add_treatment_req_model.dart';
import '../../models/treatment_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/extentions.dart';
import '../../view_models/treatment_view_model.dart';
import '../build_textfield.dart';

class EditTreatmentDialog extends ConsumerStatefulWidget {
  const EditTreatmentDialog({super.key});

  @override
  ConsumerState<EditTreatmentDialog> createState() =>
      EditTreatmentDialogState();
}

class EditTreatmentDialogState extends ConsumerState<EditTreatmentDialog> {
  @override
  void initState() {
    super.initState();
    final provider = ref.read(treatmentViewModelProvider);
    final fromProvider = provider.treatments.firstWhere(
      (e) => e.id == provider.selectedTreatmentId,
    );
    // Work on a copy so we don't mutate provider state; ensures unselect/select updates UI
    _selectedTreatment =
        TreatmentModel(
            id: fromProvider.id,
            name: fromProvider.name,
            description: fromProvider.description,
            isArea: true,
          )
          ..price = fromProvider.price
          ..sideAreas = fromProvider.sideAreas
              ?.map(
                (e) => SideAreaModel(
                  id: e.id,
                  name: e.name,
                  perSyringePrice: e.perSyringePrice,
                  maxSyringe: e.maxSyringe ?? 0,
                ),
              )
              .toList();

    _treatmentPriceControllers = TextEditingController(
      text: _selectedTreatment!.price.toString(),
    );

    if (_selectedTreatment!.sideAreas != null &&
        _selectedTreatment!.sideAreas!.isNotEmpty) {
      _loadingAreas = true;
      // One controller per selected side area, in the same order
      for (var e in _selectedTreatment!.sideAreas!) {
        e.maxSyringe != 0
            ? _areaPriceControllers.add(
                TextEditingController(
                  text: e.perSyringePrice?.toString() ?? '',
                ),
              )
            : null;
      }
      // Fetch full list of side areas once (outside the loop)
      // ref
      //     .read(treatmentViewModelProvider.notifier)
      //     .getTreatmentsSideAreas(treatmentId: _selectedTreatment!.id!)
      //     .then((areas) {
      //       if (mounted) {
      //         setState(() {
      //           _sideAreas = areas;
      //           _loadingAreas = false;
      //         });
      //       }
      //     });
    } else {
      _sideAreas = _selectedTreatment!.sideAreas ?? [];
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TreatmentModel? _selectedTreatment;
  final List<TextEditingController> _areaPriceControllers = [];
  late List<SideAreaModel> _sideAreas;
  // late List<SideAreaModel> _selectedSideAreas;
  bool _loadingAreas = false;
  late TextEditingController _treatmentPriceControllers;

  @override
  void dispose() {
    for (final c in _areaPriceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Treatment', style: CustomFonts.black22w600),
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              // Text("Select Treatment", style: CustomFonts.black14w500),
              // SizedBox(height: 8.h),
              AbsorbPointer(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<TreatmentModel>(
                    isExpanded: true,
                    hint: Text(
                      _selectedTreatment?.name ?? "N/A",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    value: _selectedTreatment,
                    items: [],
                    onChanged: (value) {},
                    buttonStyleData: ButtonStyleData(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: BuildTextField(
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.parse(value) == 0) {
                      return 'Price is required';
                    }
                    return null;
                  },

                  label: '${_selectedTreatment?.name ?? "N/A"} Treatment Price',
                  controller: _treatmentPriceControllers,
                  hintText: '\$200',
                ),
              ),
              Text("Select Areas", style: CustomFonts.black14w500),

              if ((_selectedTreatment?.isArea ?? false) && _loadingAreas) ...[
                SizedBox(height: 16.h),

                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(8, (index) {
                    return Container(
                      height: 48.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ).withShimmer();
                  }).toList(),
                ),
              ],

              if ((_selectedTreatment?.isArea ?? false) && !_loadingAreas) ...[
                SizedBox(height: 16.h),

                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: (_sideAreas).map((area) {
                    final isSelected = _selectedTreatment!.sideAreas!.any(
                      (e) => e.id == area.id,
                    );
                    return ChoiceChip(
                      label: Text(area.name ?? "N/A"),
                      selected: isSelected,
                      selectedColor: Colors.black,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTreatment!.sideAreas!.add(area);
                            // Only add a controller if this area has per-syringe price (maxSyringe != 0)
                            if (area.maxSyringe != 0) {
                              _areaPriceControllers.add(
                                TextEditingController(),
                              );
                            }
                          } else {
                            final index = _selectedTreatment!.sideAreas!
                                .indexWhere((e) => e.id == area.id);
                            if (index != -1) {
                              final areaToRemove =
                                  _selectedTreatment!.sideAreas![index];
                              // Controller index = count of areas with maxSyringe!=0 before this index (must compute before remove)
                              final controllerIndex =
                                  areaToRemove.maxSyringe != 0
                                  ? _selectedTreatment!.sideAreas!
                                        .sublist(0, index)
                                        .where((e) => e.maxSyringe != 0)
                                        .length
                                  : -1;
                              _selectedTreatment!.sideAreas!.removeAt(index);
                              if (controllerIndex >= 0) {
                                _areaPriceControllers[controllerIndex]
                                    .dispose();
                                _areaPriceControllers.removeAt(controllerIndex);
                              }
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 30.h),
                Column(
                  // _areaPriceControllers has one entry per area with maxSyringe != 0; use controllerIndex for that list
                  children: () {
                    int controllerIndex = 0;
                    return List.generate(
                      _selectedTreatment!.sideAreas!.length,
                      (index) {
                        final area = _selectedTreatment!.sideAreas![index];
                        if (area.maxSyringe != 0) {
                          final ctrlIndex = controllerIndex++;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: BuildTextField(
                              onChanged: (value) {
                                _selectedTreatment!
                                    .sideAreas![index]
                                    .perSyringePrice = double.tryParse(
                                  value ?? '0',
                                );
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.tryParse(value) == 0) {
                                  return 'Price is required';
                                }
                                return null;
                              },
                              label: '${area.name} Per Syringe Price',
                              controller: _areaPriceControllers[ctrlIndex],
                              hintText: '\$200',
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    );
                  }(),
                ),
              ],
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 2️⃣ If treatments or side areas are loading
                        if (_loadingAreas) {
                          EasyLoading.showError('Please wait while we load');
                          return;
                        }

                        // 2️⃣ If treatment has areas → at least one area required
                        if (_selectedTreatment!.isArea == true &&
                            _selectedTreatment!.sideAreas!.isEmpty) {
                          EasyLoading.showError(
                            'Please select at least one area',
                          );
                          return;
                        }
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValid) {
                          return;
                        }
                        // ref
                        //     .read(treatmentViewModelProvider.notifier)
                        //     .editClinicTreatment(
                        //       treatment: AddTreatmentReqModel(
                        //         treatmentId: _selectedTreatment!.id!,
                        //         treatmentPrice:
                        //             double.tryParse(
                        //               _treatmentPriceControllers.text,
                        //             ) ??
                        //             0,
                        //         // sideareas: _selectedTreatment!.sideAreas!,
                        //       ),
                        //     )
                        //     .then((value) {
                        //       if (value && context.mounted) {
                        //         context.pop();
                        //       }
                        //     });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                      ),
                      child: Text('Update', style: CustomFonts.white14w500),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(), // close dialog
                      child: Text('Cancel', style: CustomFonts.black18w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
