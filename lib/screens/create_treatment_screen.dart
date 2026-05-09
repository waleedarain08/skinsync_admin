import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/widgets/autocomplete_search_field.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class CreateTreatmentScreen extends ConsumerStatefulWidget {
  const CreateTreatmentScreen({super.key});

  static const String routeName = '/create-treatment';

  @override
  ConsumerState<CreateTreatmentScreen> createState() => _CreateTreatmentScreenState();
}

class _CreateTreatmentScreenState extends ConsumerState<CreateTreatmentScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 1 Controllers
  final _internalNameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _fullDescriptionController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  XFile? _treatmentImage;
  XFile? _treatmentIcon;

  // Step 2 Data
  String _selectedCategory = "";
  String _selectedSubcategory = "";
  final List<String> _categories = ["Injectables", "Skin Treatments", "Laser & Energy"];
  final Map<String, List<String>> _subcategories = {
    "Injectables": ["Neurotoxins", "Dermal Fillers"],
    "Skin Treatments": ["Facials", "Chemical Peels"],
    "Laser & Energy": ["Resurfacing", "Tightening"],
  };

  // Step 3 Data
  final List<AreaEntry> _areas = [AreaEntry()];
  final List<String> _suggestedAreas = [
    "Upper Face", "Mid Face", "Lower Face", "Neck", "Abdomen", "Arms", "Thighs", "Flanks"
  ];
  final Map<String, List<String>> _suggestedSubAreas = {
    "Upper Face": ["Forehead", "Glabella (Frown Lines)", "Crow's Feet"],
    "Mid Face": ["Cheeks", "Under Eye (Tear Trough)", "Nose"],
    "Lower Face": ["Lips", "Chin", "Jawline", "Marionette Lines"],
    "Neck": ["Neck Bands"],
  };

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _internalNameController.dispose();
    _displayNameController.dispose();
    _fullDescriptionController.dispose();
    _shortDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isIcon) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isIcon) {
          _treatmentIcon = image;
        } else {
          _treatmentImage = image;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Create New Treatment", style: CustomFonts.textMain20w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.textMain),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 900.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildCurrentStepContent(),
                        SizedBox(height: 48.h),
                        _buildActionButtons(),
                        SizedBox(height: 100.h), // Extra space for autocomplete overlays
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
      child: Row(
        children: [
          _stepIndicator(0, "Basic Details"),
          _stepConnector(0),
          _stepIndicator(1, "Category"),
          _stepConnector(1),
          _stepIndicator(2, "Areas"),
        ],
      ),
    );
  }

  Widget _stepIndicator(int step, String label) {
    final bool isActive = _currentStep >= step;
    final bool isCompleted = _currentStep > step;

    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: isCompleted ? CustomColors.success : (isActive ? CustomColors.brandPrimary : Colors.white),
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? Colors.transparent : Colors.grey[300]!),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    "${step + 1}",
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          label,
          style: CustomFonts.textMain14w600.copyWith(
            color: isActive ? CustomColors.textMain : Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _stepConnector(int step) {
    final bool isCompleted = _currentStep > step;
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        height: 2.h,
        color: isCompleted ? CustomColors.success : Colors.grey[200],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Basic Information"),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: "Internal Treatment Name",
                controller: _internalNameController,
                hintText: "e.g. Botox Cosmetic",
                validator: Validators.empty,
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: BuildTextField(
                label: "Patient Display Name",
                controller: _displayNameController,
                hintText: "e.g. Wrinkle Relaxer",
                validator: Validators.empty,
              ),
            ),
          ],
        ),
        SizedBox(height: 32.h),
        _sectionTitle("Visuals"),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(child: _buildImageUploadTile("Treatment Banner Image", _treatmentImage, () => _pickImage(false))),
            SizedBox(width: 24.w),
            Expanded(child: _buildImageUploadTile("Treatment Listing Icon", _treatmentIcon, () => _pickImage(true))),
          ],
        ),
        SizedBox(height: 32.h),
        _sectionTitle("Descriptions"),
        SizedBox(height: 24.h),
        BuildTextField(
          label: "Short Description",
          controller: _shortDescriptionController,
          hintText: "Brief summary for listing (e.g. Smooth fine lines and wrinkles)...",
          maxLines: 2,
        ),
        SizedBox(height: 24.h),
        BuildTextField(
          label: "Full Description",
          controller: _fullDescriptionController,
          hintText: "Detailed medical and process information for patient education...",
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Categorization"),
        SizedBox(height: 8.h),
        Text("Organize treatments to help patients find them easily.", style: CustomFonts.textMuted14w400),
        SizedBox(height: 32.h),
        AutocompleteSearchField(
          label: "Treatment Category",
          hintText: "Select or type a category (e.g. Injectables)",
          suggestions: _categories,
          onSelected: (val) => setState(() => _selectedCategory = val),
        ),
        SizedBox(height: 32.h),
        AutocompleteSearchField(
          label: "Treatment Subcategory",
          hintText: "Select or type a subcategory (e.g. Neurotoxins)",
          suggestions: _subcategories[_selectedCategory] ?? [],
          onSelected: (val) => setState(() => _selectedSubcategory = val),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("Treatment Areas"),
                SizedBox(height: 4.h),
                Text("Specify which parts of the body this treatment applies to.", style: CustomFonts.textMuted14w400),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => setState(() => _areas.add(AreaEntry())),
              icon: const Icon(Icons.add_location_alt_outlined, size: 18),
              label: const Text("Add New Area"),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.brandCyan.withValues(alpha: 0.1),
                foregroundColor: CustomColors.brandPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 32.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _areas.length,
          separatorBuilder: (_, __) => SizedBox(height: 24.h),
          itemBuilder: (context, index) {
            return _buildAreaRow(index);
          },
        ),
      ],
    );
  }

  Widget _buildAreaRow(int index) {
    final entry = _areas[index];
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AutocompleteSearchField(
                  label: "Area Name",
                  hintText: "e.g. Upper Face",
                  suggestions: _suggestedAreas,
                  onSelected: (val) => setState(() => entry.area = val),
                ),
              ),
              if (_areas.length > 1)
                Padding(
                  padding: EdgeInsets.only(top: 32.h, left: 16.w),
                  child: IconButton(
                    onPressed: () => setState(() => _areas.removeAt(index)),
                    icon: const Icon(Icons.delete_outline, color: CustomColors.error),
                  ),
                ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildSubAreaSection(entry),
        ],
      ),
    );
  }

  Widget _buildSubAreaSection(AreaEntry entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutocompleteSearchField(
          label: "Sub Areas (Optional)",
          hintText: "Select or type to add sub areas (e.g. Forehead)",
          suggestions: _suggestedSubAreas[entry.area] ?? [],
          onSelected: (val) {
            if (val.isNotEmpty && !entry.subAreas.contains(val)) {
              setState(() => entry.subAreas.add(val));
            }
          },
        ),
        if (entry.subAreas.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: entry.subAreas.map((sub) {
              return Chip(
                label: Text(sub, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                onDeleted: () => setState(() => entry.subAreas.remove(sub)),
                deleteIcon: const Icon(Icons.close, size: 16),
                backgroundColor: CustomColors.brandCyan.withValues(alpha: 0.1),
                side: BorderSide(color: CustomColors.brandCyan.withValues(alpha: 0.2)),
                labelStyle: const TextStyle(color: CustomColors.brandPrimary),
                deleteIconColor: CustomColors.brandPrimary,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildImageUploadTile(String label, XFile? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.textMain14w600),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 160.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey[200]!, width: 2),
              image: file != null
                  ? DecorationImage(
                      image: kIsWeb ? NetworkImage(file.path) : FileImage(File(file.path)) as ImageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: file == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(color: CustomColors.surfaceGhost, shape: BoxShape.circle),
                        child: const Icon(Icons.add_a_photo_outlined, color: CustomColors.brandPrimary),
                      ),
                      SizedBox(height: 12.h),
                      Text("Tap to upload", style: CustomFonts.textMuted13w500),
                    ],
                  )
                : Stack(
                    children: [
                      Positioned(
                        right: 8.r,
                        top: 8.r,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          radius: 14.r,
                          child: const Icon(Icons.edit, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: CustomFonts.textMain20w600);
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_currentStep > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _currentStep -= 1),
              child: const Text("Previous Step"),
            ),
          ),
          SizedBox(width: 16.w),
        ],
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              if (_currentStep < 2) {
                setState(() => _currentStep += 1);
              } else {
                _submit();
              }
            },
            child: Text(_currentStep == 2 ? "Finish & Create Treatment" : "Next Step"),
          ),
        ),
      ],
    );
  }

  void _submit() {
    // Collect data and send to ViewModel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Treatment created successfully!"),
        backgroundColor: CustomColors.success,
      ),
    );
    context.pop();
  }
}

class AreaEntry {
  String area = "";
  List<String> subAreas = [];
}
