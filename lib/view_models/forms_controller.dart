import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:camera/camera.dart' show XFile;
import '../models/form_template.dart';

class FormsController {
  static const String _storageKey = 'saved_forms';
  List<FormTemplate> _forms = [];
  bool _isLoading = true;

  List<FormTemplate> get forms => _forms;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    await loadForms();
  }
Future<void> loadForms() async {
  _isLoading = true;

  final prefs = await SharedPreferences.getInstance();
  final String? formsJson = prefs.getString(_storageKey);

  if (formsJson != null) {
    final List<dynamic> decoded =
        json.decode(formsJson) as List<dynamic>;

    _forms = decoded
        .map((item) => FormTemplate.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  _isLoading = false;
}
  Future<void> saveForm(FormTemplate form) async {
    _forms.insert(0, form);
    await _persistForms();
  }

  Future<void> deleteForm(String id) async {
    final formIndex = _forms.indexWhere((f) => f.id == id);
    if (formIndex != -1) {
      final form = _forms[formIndex];
      if (!kIsWeb) {
        try {
          final file = File(form.filePath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // Log or handle file deletion error
        }
      }
      _forms.removeAt(formIndex);
      await _persistForms();
    }
  }

  Future<void> _persistForms() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_forms.map((f) => f.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<FormTemplate> uploadPdf(XFile pickedFile, String name) async {
    String filePath = '';
    if (kIsWeb) {
      filePath = pickedFile.name;
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          "${name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final bytes = await pickedFile.readAsBytes();
      final savedFile = File("${appDir.path}/$fileName");
      await savedFile.writeAsBytes(bytes);
      filePath = savedFile.path;
    }

    final newForm = FormTemplate(
      id: const Uuid().v4(),
      name: name,
      filePath: filePath,
      createdAt: DateTime.now(),
      isUserCreated: false,
    );

    await saveForm(newForm);
    return newForm;
  }

  String getUniqueName(String baseName) {
    String currentName = baseName;
    int counter = 1;
    while (_forms.any(
      (f) => f.name.toLowerCase() == currentName.toLowerCase(),
    )) {
      counter++;
      currentName = "$baseName ($counter)";
    }
    return currentName;
  }
}
