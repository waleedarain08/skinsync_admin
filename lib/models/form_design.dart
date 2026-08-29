import 'form_component.dart';

enum PageFormatType { a4, letter, legal }

enum PageOrientation { portrait, landscape }

class FormPage {
  final List<FormComponent> components;

  FormPage({required this.components});

  Map<String, dynamic> toMap() => {
        'components': components.map((c) => c.toMap()).toList(),
      };

  factory FormPage.fromMap(Map<String, dynamic> map) => FormPage(
        components: (map['components'] as List)
            .map((c) => FormComponent.fromMap(c))
            .toList(),
      );
}

class FormDesign {
  final List<FormPage> pages;
  PageFormatType format;
  PageOrientation orientation;
  double margin;

  FormDesign({
    required this.pages,
    this.format = PageFormatType.a4,
    this.orientation = PageOrientation.portrait,
    this.margin = 20.0,
  });

  Map<String, dynamic> toMap() => {
        'pages': pages.map((p) => p.toMap()).toList(),
        'format': format.name,
        'orientation': orientation.name,
        'margin': margin,
      };

  factory FormDesign.fromMap(Map<String, dynamic> map) => FormDesign(
        pages: (map['pages'] as List).map((p) => FormPage.fromMap(p)).toList(),
        format: PageFormatType.values.firstWhere((e) => e.name == map['format'],
            orElse: () => PageFormatType.a4),
        orientation: PageOrientation.values.firstWhere(
            (e) => e.name == map['orientation'],
            orElse: () => PageOrientation.portrait),
        margin: (map['margin'] as num?)?.toDouble() ?? 20.0,
      );
}
