import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skinsync_admin/models/form_component.dart';
import 'package:skinsync_admin/models/form_design.dart';
import 'package:uuid/uuid.dart';

import '../../models/form_template.dart';
import '../../view_models/forms_controller.dart';
import '../../services/locator.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/custom_outlined_button.dart';

class FormBuilderScreen extends StatefulWidget {
  final FormTemplate? initialForm;
  const FormBuilderScreen({super.key, this.initialForm});

  @override
  State<FormBuilderScreen> createState() => _FormBuilderScreenState();
}

class _FormBuilderScreenState extends State<FormBuilderScreen> {
  late FormDesign _design;
  int _currentPageIndex = 0;
  FormComponent? _selectedComponent;
  final TextEditingController _nameController = TextEditingController();
  final FormsController _formsController = locator<FormsController>();
  
  bool _isPreviewMode = false;
  bool _isSaving = false;

  // A4 dimensions in points (72 points per inch)
  // A4 is 8.27 x 11.69 inches -> 595 x 842 points
  static const double a4Width = 595;
  static const double a4Height = 842;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialForm?.name ?? "New Consent Form";
    
    if (widget.initialForm?.templateJson != null) {
      try {
        final decoded = jsonDecode(widget.initialForm!.templateJson!);
        _design = FormDesign.fromMap(decoded);
      } catch (e) {
        _design = _createEmptyDesign();
      }
    } else {
      _design = _createEmptyDesign();
    }
  }

  FormDesign _createEmptyDesign() {
    return FormDesign(
      pages: [FormPage(components: [])],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // void _addComponent(FormComponentType type) {
  //   final id = const Uuid().v4();
  //   final newComponent = FormComponent(
  //     id: id,
  //     type: type,
  //     label: _getDefaultLabel(type),
  //     dx: 50,
  //     dy: 50 + (_design.pages[_currentPageIndex].components.length * 10),
  //     width: _getDefaultWidth(type),
  //     height: _getDefaultHeight(type),
  //   );
  //
  //   setState(() {
  //     _design.pages[_currentPageIndex].components.add(newComponent);
  //     _selectedComponent = newComponent;
  //   });
  // }
  void _addComponent(FormComponentType type) {
    final id = const Uuid().v4();
    final components = _design.pages[_currentPageIndex].components;

    // Find bottom edge of lowest existing component
    double nextDy = 20;
    if (components.isNotEmpty) {
      nextDy = components.fold(0.0, (prev, comp) {
        final bottom = comp.dy + comp.height;
        return bottom > prev ? bottom : prev;
      }) + 12; // 12px gap
    }

    final height = _getDefaultHeight(type);

    // Clamp so it doesn't overflow the A4 page
    nextDy = nextDy.clamp(0.0, a4Height - height);

    final newComponent = FormComponent(
      id: id,
      type: type,
      label: _getDefaultLabel(type),
      dx: 20,
      dy: nextDy,
      width: _getDefaultWidth(type),
      height: height,
    );

    setState(() {
      components.add(newComponent);
      _selectedComponent = newComponent;
    });
  }
  String _getDefaultLabel(FormComponentType type) {
    switch (type) {
      case FormComponentType.heading: return "Heading";
      case FormComponentType.subHeading: return "Subheading";
      case FormComponentType.paragraph: return "Paragraph text goes here...";
      case FormComponentType.textField: return "Patient Name";
      case FormComponentType.checkbox: return "I agree";
      case FormComponentType.signature: return "Signature";
      default: return type.name.toUpperCase();
    }
  }

  double _getDefaultWidth(FormComponentType type) {
    switch (type) {
      case FormComponentType.heading:
      case FormComponentType.subHeading:
      case FormComponentType.paragraph:
      case FormComponentType.divider:
        return a4Width - 100;
      case FormComponentType.signature:
        return 200;
      default:
        return 250;
    }
  }

  double _getDefaultHeight(FormComponentType type) {
    switch (type) {
      case FormComponentType.heading: return 40;
      case FormComponentType.subHeading: return 30;
      case FormComponentType.paragraph: return 60;
      case FormComponentType.textArea: return 100;
      case FormComponentType.signature: return 80;
      case FormComponentType.divider: return 20;
      default: return 50;
    }
  }

  Future<void> _saveForm() async {
    if (_nameController.text.isEmpty) {
      _showSnackBar("Please enter a form name", isError: true);
      return;
    }

    setState(() => _isSaving = true);
    try {
      final name = _formsController.getUniqueName(_nameController.text);
      // PDF generation would go here using PdfService
      // For now, we focus on the builder structure
      
      final template = FormTemplate(
        id: widget.initialForm?.id ?? const Uuid().v4(),
        name: name,
        filePath: '', // PDF generation skipped for now as per instructions to focus on builder
        templateJson: jsonEncode(_design.toMap()),
        createdAt: DateTime.now(),
        isUserCreated: true,
      );

      await _formsController.saveForm(template);
      
      if (mounted) {
        _showSnackBar("Form saved successfully");
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar("Failed to save form: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? CustomColors.red : CustomColors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.softGrey,
      appBar: _buildAppBar(),
      body: Row(
        children: [
          if (!_isPreviewMode) _buildLeftPanel(),
          Expanded(child: _buildCanvasArea()),
          if (!_isPreviewMode && _selectedComponent != null) _buildRightPanel(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: CustomColors.white,
      elevation: 0,
      title: TextField(
        controller: _nameController,
        style: context.fonts.black18w600,
        decoration: const InputDecoration(border: InputBorder.none, hintText: "Form Name"),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => setState(() => _isPreviewMode = !_isPreviewMode),
          icon: Icon(_isPreviewMode ? Icons.edit : Icons.remove_red_eye),
          label: Text(_isPreviewMode ? "Edit" : "Preview"),
        ),
        SizedBox(width: 12.w),
        CustomPrimaryButton(
          label: "Save Form",
          onTap: _saveForm,
          isLoading: _isSaving,
          width: 140.w,
          height: 40.h,
        ),
        SizedBox(width: 16.w),
      ],
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      width: 280.w,
      decoration: const BoxDecoration(
        color: CustomColors.white,
        border: Border(right: BorderSide(color: CustomColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text("Components", style: context.fonts.black16w600),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12.w),
              children: [
                _buildComponentGroup("Text Elements", [
                  _componentTile(FormComponentType.heading, "Heading", Icons.title),
                  _componentTile(FormComponentType.subHeading, "Sub Heading", Icons.text_fields),
                  _componentTile(FormComponentType.paragraph, "Paragraph", Icons.notes),
                ]),
                _buildComponentGroup("Form Fields", [
                  _componentTile(FormComponentType.textField, "Text Field", Icons.short_text),
                  _componentTile(FormComponentType.textArea, "Text Area", Icons.subject),
                  _componentTile(FormComponentType.numberField, "Number", Icons.numbers),
                  _componentTile(FormComponentType.emailField, "Email", Icons.email_outlined),
                  _componentTile(FormComponentType.dateField, "Date", Icons.calendar_today),
                  _componentTile(FormComponentType.checkbox, "Checkbox", Icons.check_box_outlined),
                  _componentTile(FormComponentType.radioGroup, "Radio Group", Icons.radio_button_checked),
                  _componentTile(FormComponentType.dropdown, "Dropdown", Icons.arrow_drop_down_circle_outlined),
                  _componentTile(FormComponentType.toggle, "Toggle", Icons.toggle_on_outlined),
                ]),
                _buildComponentGroup("Signatures", [
                  _componentTile(FormComponentType.signature, "Signature", Icons.gesture),
                  _componentTile(FormComponentType.initials, "Initials", Icons.person_outline),
                ]),
                _buildComponentGroup("Layout", [
                  _componentTile(FormComponentType.divider, "Divider", Icons.horizontal_rule),
                  _componentTile(FormComponentType.spacer, "Spacer", Icons.space_bar),
                ]),
                _buildComponentGroup("Media", [
                  _componentTile(FormComponentType.image, "Image", Icons.image_outlined),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, top: 16.h, bottom: 8.h),
          child: Text(title.toUpperCase(), style: context.fonts.grey11w600ls12),
        ),
        ...children,
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _componentTile(FormComponentType type, String label, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: InkWell(
        onTap: () => _addComponent(type),
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: CustomColors.purple),
              SizedBox(width: 12.w),
              Text(label, style: context.fonts.black13w500),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCanvasArea() {
    return Container(
      color: CustomColors.softGrey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
        child: Column(
          children: [
            for (int i = 0; i < _design.pages.length; i++)
              _buildPage(i),
            if (!_isPreviewMode)
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: CustomOutlinedButton(
                  label: "Add Page",
                  onTap: () => setState(() {
                    _design.pages.add(FormPage(components: []));
                  }),
                  width: 150.w,
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildPage(int pageIndex) {
    return Center(
      child: Container(
        width: a4Width,
        height: a4Height,
        margin: EdgeInsets.only(bottom: 40.h),
        decoration: BoxDecoration(
          color: CustomColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Page Number Indicator (Visual only)
            Positioned(
              top: 10,
              right: 20,
              child: Text("Page ${pageIndex + 1}", style: context.fonts.grey11w600),
            ),
            
            // Background grid (optional, for builder)
            if (!_isPreviewMode)
              CustomPaint(
                size: const Size(a4Width, a4Height),
                painter: GridPainter(),
              ),

            // Elements
            for (var comp in _design.pages[pageIndex].components)
              _buildPositionedComponent(comp, pageIndex),

          ],
        ),
      ),
    );
  }

  Widget _buildPositionedComponent(FormComponent comp, int pageIndex) {
    final bool isSelected = _selectedComponent?.id == comp.id && !_isPreviewMode;
    return Positioned(
      left: comp.dx,
      top: comp.dy,
      width: comp.width,
      height: comp.height,
      child: GestureDetector(
        onTap: () {
          if (!_isPreviewMode) {
            setState(() {
              _selectedComponent = comp;
              _currentPageIndex = pageIndex;
            });
          }
        },
        onPanUpdate: (details) {
          if (!_isPreviewMode) {
            setState(() {
              comp.dx += details.delta.dx;
              comp.dy += details.delta.dy;
              // Bounds checking
              comp.dx = comp.dx.clamp(0.0, a4Width - comp.width);
              comp.dy = comp.dy.clamp(0.0, a4Height - comp.height);
              _selectedComponent = comp;
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: isSelected ? Border.all(color: CustomColors.purple, width: 2) : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              FormElementRenderer(component: comp, isPreview: _isPreviewMode),

              // Controls overlay when selected
              if (isSelected) ...[
                // Resize Handle (Bottom Right)
                Positioned(
                  right: -5,
                  bottom: -5,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        comp.width = (comp.width + details.delta.dx).clamp(50.0, a4Width - comp.dx);
                        comp.height = (comp.height + details.delta.dy).clamp(20.0, a4Height - comp.dy);
                      });
                    },
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(color: CustomColors.purple, shape: BoxShape.circle),
                    ),
                  ),
                ),
                // Delete Button
                Positioned(
                  top: -10,
                  right: -10,
                  child: InkWell(
                    onTap: () => setState(() {
                      print('hello world');
                      _design.pages[pageIndex].components.remove(comp);
                      _selectedComponent = null;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    final comp = _selectedComponent!;
    return Container(
      width: 320.w,
      decoration: const BoxDecoration(
        color: CustomColors.white,
        border: Border(left: BorderSide(color: CustomColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Properties", style: context.fonts.black16w600),
                IconButton(
                  onPressed: () => setState(() => _selectedComponent = null),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                _buildPropGroup("General", [
                  _propTextField("Label", comp.label, (val) => setState(() => comp.label = val)),
                  _propTextField("Field Name", comp.fieldName, (val) => setState(() => comp.fieldName = val)),
                  _propTextField("Help Text", comp.helpText, (val) => setState(() => comp.helpText = val)),
                ]),
                if (_isFormField(comp.type))
                  _buildPropGroup("Validation", [
                    _propSwitch("Required", comp.isRequired, (val) => setState(() => comp.isRequired = val)),
                    _propTextField("Default Value", comp.defaultValue?.toString() ?? "", (val) => setState(() => comp.defaultValue = val)),
                  ]),
                _buildPropGroup("Layout", [
                  Row(
                    children: [
                      Expanded(child: _propTextField("Width", comp.width.toInt().toString(), (val) => setState(() => comp.width = double.tryParse(val) ?? comp.width))),
                      SizedBox(width: 12.w),
                      Expanded(child: _propTextField("Height", comp.height.toInt().toString(), (val) => setState(() => comp.height = double.tryParse(val) ?? comp.height))),
                    ],
                  ),
                ]),
                _buildPropGroup("Styling", [
                  _propSlider("Font Size", comp.fontSize, 8, 72, (val) => setState(() => comp.fontSize = val)),
                  Row(
                    children: [
                      _propToggle("Bold", comp.isBold, (val) => setState(() => comp.isBold = val)),
                      SizedBox(width: 12.w),
                      _propToggle("Italic", comp.isItalic, (val) => setState(() => comp.isItalic = val)),
                    ],
                  ),
                ]),
                
                SizedBox(height: 32.h),
                CustomOutlinedButton(
                  label: "Duplicate Element",
                  onTap: () {
                    final newComp = comp.copyWith(
                      dx: comp.dx + 20,
                      dy: comp.dy + 20,
                    );
                    setState(() {
                      _design.pages[pageIndex].components.add(newComp);
                      _selectedComponent = newComp;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to determine if we need to get pageIndex for duplication
  int get pageIndex => _currentPageIndex;

  bool _isFormField(FormComponentType type) {
    return type != FormComponentType.heading &&
           type != FormComponentType.subHeading &&
           type != FormComponentType.paragraph &&
           type != FormComponentType.divider &&
           type != FormComponentType.spacer;
  }

  Widget _buildPropGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Text(title, style: context.fonts.black12w600),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _propTextField(String label, String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        key: ValueKey("${_selectedComponent?.id}_$label"),
        initialValue: value,
        onChanged: onChanged,
        decoration: AppDecorations.input(context, hint: label),
        style: context.fonts.black12w400,
      ),
    );
  }

  Widget _propSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.fonts.black12w400),
        Switch(value: value, onChanged: onChanged, activeTrackColor: CustomColors.purple),
      ],
    );
  }

  Widget _propSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ${value.toInt()}", style: context.fonts.black11w400),
        Slider(value: value, min: min, max: max, onChanged: onChanged, activeColor: CustomColors.purple),
      ],
    );
  }

  Widget _propToggle(String label, bool active, ValueChanged<bool> onChanged) {
    return FilterChip(
      label: Text(label),
      selected: active,
      onSelected: onChanged,
      selectedColor: CustomColors.purple.withValues(alpha: 0.2),
      checkmarkColor: CustomColors.purple,
    );
  }
}

class FormElementRenderer extends StatelessWidget {
  final FormComponent component;
  final bool isPreview;
  const FormElementRenderer({super.key, required this.component, required this.isPreview});

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontSize: component.fontSize,
      fontWeight: component.isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: component.isItalic ? FontStyle.italic : FontStyle.normal,
      color: component.textColor != null ? Color(component.textColor!) : Colors.black,
    );

    switch (component.type) {
      case FormComponentType.heading:
        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: _getAlignment(component.alignment),
          child: Text(component.label, style: style.copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
        );
      case FormComponentType.subHeading:
        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: _getAlignment(component.alignment),
          child: Text(component.label, style: style.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
        );
      case FormComponentType.paragraph:
        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: _getAlignment(component.alignment),
          child: Text(component.label, style: style),
        );
      case FormComponentType.textField:
      case FormComponentType.emailField:
      case FormComponentType.numberField:
      case FormComponentType.phoneField:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (component.label.isNotEmpty)
              Text(component.label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
              height: 30,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black45))),
              alignment: Alignment.centerLeft,
              child: Text(component.placeholder, style: const TextStyle(color: Colors.black26, fontSize: 12)),
            ),
          ],
        );
      case FormComponentType.checkbox:
        return Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(border: Border.all(color: Colors.black45)),
              child: isPreview ? null : const Icon(Icons.check, size: 14, color: Colors.transparent),
            ),
            const SizedBox(width: 8),
            Text(component.label, style: style),
          ],
        );
      case FormComponentType.radioGroup:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(component.label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            const Spacer(),
            Row(
              children: [
                _radioCircle(), const SizedBox(width: 4), const Text("Yes", style: TextStyle(fontSize: 10)),
                const SizedBox(width: 12),
                _radioCircle(), const SizedBox(width: 4), const Text("No", style: TextStyle(fontSize: 10)),
              ],
            ),
          ],
        );
      case FormComponentType.dropdown:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(component.label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
              height: 30,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(component.placeholder.isNotEmpty ? component.placeholder : "Select Option", style: const TextStyle(color: Colors.black26, fontSize: 10)),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ],
        );
      case FormComponentType.dateField:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(component.label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
              height: 30,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black45))),
              child: const Row(
                children: [
                  Text("DD / MM / YYYY", style: TextStyle(color: Colors.black26, fontSize: 10)),
                  Spacer(),
                  Icon(Icons.calendar_today, size: 14, color: Colors.black26),
                ],
              ),
            ),
          ],
        );
      case FormComponentType.signature:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(component.label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12, style: BorderStyle.solid)),
              child: Center(child: Text("Signature Here", style: context.fonts.grey11w600)),
            ),
          ],
        );
      case FormComponentType.divider:
        return const Center(child: Divider(color: Colors.black45));
      case FormComponentType.spacer:
        return const SizedBox.shrink();
      case FormComponentType.image:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(child: Icon(Icons.image_outlined, color: Colors.black12, size: 32)),
        );
      default:
        return Center(child: Text(component.label, style: style));
    }
  }

  Alignment _getAlignment(TextAlign align) {
    switch (align) {
      case TextAlign.center: return Alignment.center;
      case TextAlign.right: return Alignment.centerRight;
      default: return Alignment.centerLeft;
    }
  }

  Widget _radioCircle() => Container(width: 14, height: 14, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black45)));
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withValues(alpha: 0.05)..strokeWidth = 0.5;
    const double step = 20;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
