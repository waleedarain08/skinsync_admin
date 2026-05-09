import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';

class AutocompleteSearchField extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> suggestions;
  final Function(String) onSelected;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AutocompleteSearchField({
    super.key,
    required this.label,
    required this.hintText,
    required this.suggestions,
    required this.onSelected,
    required this.controller,
    this.validator,
  });

  @override
  State<AutocompleteSearchField> createState() => _AutocompleteSearchFieldState();
}

class _AutocompleteSearchFieldState extends State<AutocompleteSearchField> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _hideOverlay();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (!mounted) return;
    _overlayEntry = _createOverlayEntry();
    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry? _createOverlayEntry() {
    if (!mounted) return null;
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null || !(renderObject as RenderBox).hasSize) return null;
    
    final size = renderObject.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            child: Container(
              constraints: BoxConstraints(maxHeight: 250.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: widget.controller,
                builder: (context, value, child) {
                  final query = value.text.toLowerCase();
                  final filteredList = query.isEmpty 
                      ? widget.suggestions 
                      : widget.suggestions.where((s) => s.toLowerCase().contains(query)).toList();

                  if (filteredList.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text('No results found.', style: CustomFonts.textMuted12w400),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return ListTile(
                        dense: true,
                        title: Text(item, style: CustomFonts.textMain14w400),
                        onTap: () {
                          // Update text and move cursor to end
                          widget.controller.text = item;
                          widget.controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: item.length),
                          );
                          _focusNode.unfocus();
                          widget.onSelected(item);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: CustomFonts.textMain14w600),
        SizedBox(height: 10.h),
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            style: CustomFonts.textMain14w400,
            validator: widget.validator,
            onChanged: (val) => widget.onSelected(val),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: CustomFonts.textMuted14w400,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: CustomColors.brandPrimary),
              ),
              suffixIcon: const Icon(Icons.search, color: CustomColors.textMuted, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
