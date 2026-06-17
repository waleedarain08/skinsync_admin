import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  final _storage = FirebaseStorage.instance;

  static MediaService? _instance;

  MediaService._();

  factory MediaService() {
    _instance ??= MediaService._();
    return _instance!;
  }

  Future<String?> uploadImage(String path, XFile image) async {
    final storagePath = '$path/${image.name}';
    final ref = _storage.ref().child(storagePath);
    final metadata = SettableMetadata(
      contentType: _imageContentType(image.name),
    );
    final task = ref.putData(await image.readAsBytes(), metadata);
    await task.whenComplete(() {});
    final url = await ref.getDownloadURL();
    log('Uploaded image path: $storagePath');
    log('Uploaded image URL: $url');
    return url;
  }

  String _imageContentType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return switch (ext) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }

  Future<String?> uploadFile(String path, PlatformFile file) async {
    final storagePath = '$path/${file.name}';
    final ref = _storage.ref().child(storagePath);
    final metadata = SettableMetadata(
      contentType: file.extension == 'pdf'
          ? 'application/pdf'
          : 'application/octet-stream',
    );

    if (file.bytes != null) {
      final task = ref.putData(file.bytes!, metadata);
      await task.whenComplete(() {});
    } else if (file.path != null) {
      final task = ref.putFile(File(file.path!), metadata);
      await task.whenComplete(() {});
    } else {
      throw Exception('File data not available');
    }

    final url = await ref.getDownloadURL();
    log('Uploaded file path: $storagePath');
    log('Uploaded file URL: $url');
    return url;
  }

  Future<XFile?> downloadSimulationImage({
    int? simId,
    required bool isBefore,
    String? imageUrl,
  }) async {
    if (imageUrl == null) {
      return null;
    }
    final uri = Uri.parse(imageUrl);
    final ext = uri.path.split('.').last;
    final dir = await getApplicationCacheDirectory();
    final path =
        '${dir.path}/simulation_${isBefore ? 'before' : 'after'}_${simId ?? 0}.$ext';
    final file = File(path);
    if (await file.exists()) {
      return XFile(file.path);
    }
    final response = await get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    await file.writeAsBytes(response.bodyBytes);
    log('PATH: ${uri.path}');
    return XFile(path);
  }
}
