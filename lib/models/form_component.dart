import 'package:flutter/material.dart';

enum FormComponentType {
  // Text Elements
  heading,
  subHeading,
  paragraph,
  richText,
  
  // Form Fields
  textField,
  textArea,
  numberField,
  emailField,
  phoneField,
  dateField,
  timeField,
  dateTimeField,
  checkbox,
  checkboxGroup,
  radioGroup,
  dropdown,
  multiSelect,
  toggle,
  
  // Signature
  signature,
  initials,
  
  // Layout
  divider,
  spacer,
  section,
  card,
  container,
  columns,
  rowLayout,
  pageBreak,
  
  // Media
  image,
  logo,
  icon,
  
  // Advanced
  table,
  repeatingSection,
  notesArea,
  readOnlyLabel,
}

class FormComponent {
  final String id;
  final FormComponentType type;
  String label;
  String fieldName;
  String placeholder;
  String helpText;
  
  // Validation
  bool isRequired;
  int? minLength;
  int? maxLength;
  String? regex;
  dynamic defaultValue;

  // Layout & Positioning
  double dx;
  double dy;
  double width;
  double height;
  TextAlign alignment;
  
  // Styling
  double fontSize;
  bool isBold;
  bool isItalic;
  int? textColor; // ARGB
  int? backgroundColor;
  int? borderColor;
  double borderRadius;
  double borderWidth;

  // Type-specific data
  List<String> options;

  FormComponent({
    required this.id,
    required this.type,
    this.label = '',
    this.fieldName = '',
    this.placeholder = '',
    this.helpText = '',
    this.isRequired = false,
    this.minLength,
    this.maxLength,
    this.regex,
    this.defaultValue,
    this.dx = 0,
    this.dy = 0,
    this.width = 200,
    this.height = 50,
    this.alignment = TextAlign.left,
    this.fontSize = 14.0,
    this.isBold = false,
    this.isItalic = false,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 0,
    this.borderWidth = 0,
    this.options = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'fieldName': fieldName,
      'placeholder': placeholder,
      'helpText': helpText,
      'isRequired': isRequired,
      'minLength': minLength,
      'maxLength': maxLength,
      'regex': regex,
      'defaultValue': defaultValue,
      'dx': dx,
      'dy': dy,
      'width': width,
      'height': height,
      'alignment': alignment.index,
      'fontSize': fontSize,
      'isBold': isBold,
      'isItalic': isItalic,
      'textColor': textColor,
      'backgroundColor': backgroundColor,
      'borderColor': borderColor,
      'borderRadius': borderRadius,
      'borderWidth': borderWidth,
      'options': options,
    };
  }

  factory FormComponent.fromMap(Map<String, dynamic> map) {
    return FormComponent(
      id: map['id'],
      type: FormComponentType.values.firstWhere((e) => e.name == map['type']),
      label: map['label'] ?? '',
      fieldName: map['fieldName'] ?? '',
      placeholder: map['placeholder'] ?? '',
      helpText: map['helpText'] ?? '',
      isRequired: map['isRequired'] ?? false,
      minLength: map['minLength'],
      maxLength: map['maxLength'],
      regex: map['regex'],
      defaultValue: map['defaultValue'],
      dx: (map['dx'] as num).toDouble(),
      dy: (map['dy'] as num).toDouble(),
      width: (map['width'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
      alignment: TextAlign.values[map['alignment'] ?? 0],
      fontSize: (map['fontSize'] as num?)?.toDouble() ?? 14.0,
      isBold: map['isBold'] ?? false,
      isItalic: map['isItalic'] ?? false,
      textColor: map['textColor'],
      backgroundColor: map['backgroundColor'],
      borderColor: map['borderColor'],
      borderRadius: (map['borderRadius'] as num?)?.toDouble() ?? 0,
      borderWidth: (map['borderWidth'] as num?)?.toDouble() ?? 0,
      options: List<String>.from(map['options'] ?? []),
    );
  }

  FormComponent copyWith({
    String? label,
    String? fieldName,
    String? placeholder,
    String? helpText,
    bool? isRequired,
    int? minLength,
    int? maxLength,
    String? regex,
    dynamic defaultValue,
    double? dx,
    double? dy,
    double? width,
    double? height,
    TextAlign? alignment,
    double? fontSize,
    bool? isBold,
    bool? isItalic,
    int? textColor,
    int? backgroundColor,
    int? borderColor,
    double? borderRadius,
    double? borderWidth,
    List<String>? options,
  }) {
    return FormComponent(
      id: id,
      type: type,
      label: label ?? this.label,
      fieldName: fieldName ?? this.fieldName,
      placeholder: placeholder ?? this.placeholder,
      helpText: helpText ?? this.helpText,
      isRequired: isRequired ?? this.isRequired,
      minLength: minLength ?? this.minLength,
      maxLength: maxLength ?? this.maxLength,
      regex: regex ?? this.regex,
      defaultValue: defaultValue ?? this.defaultValue,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      width: width ?? this.width,
      height: height ?? this.height,
      alignment: alignment ?? this.alignment,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      options: options ?? this.options,
    );
  }
}
