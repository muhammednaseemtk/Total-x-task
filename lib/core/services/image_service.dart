import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  String _directoryNameFor(String ownerId) {
    return base64Url.encode(utf8.encode(ownerId)).replaceAll('=', '');
  }

  Future<String> _imagesDirectory({required String ownerId}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(
      '${appDir.path}/user_images/${_directoryNameFor(ownerId)}',
    );
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir.path;
  }

  Future<String?> pickImageFromGallery({required String ownerId}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        return await saveImage(image.path, ownerId: ownerId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> pickImageFromCamera({required String ownerId}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        return await saveImage(image.path, ownerId: ownerId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String> saveImage(String sourcePath, {required String ownerId}) async {
    final file = File(sourcePath);
    if (!await file.exists()) {
      throw Exception('Source image file not found');
    }

    final extension = sourcePath.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
    final imagesDir = await _imagesDirectory(ownerId: ownerId);
    final destinationPath = '$imagesDir/$fileName';

    await file.copy(destinationPath);
    return destinationPath;
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore deletion errors
    }
  }

  bool imageExists(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;
    return File(imagePath).existsSync();
  }
}
