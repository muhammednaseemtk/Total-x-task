import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class LocalImageService {
  final ImagePicker _picker = ImagePicker();
  
  Future<String> get _imagesDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/user_images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir.path;
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        return await saveImage(image.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        return await saveImage(image.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String> saveImage(String sourcePath) async {
    final file = File(sourcePath);
    if (!await file.exists()) {
      throw Exception('Source image file not found');
    }

    final extension = sourcePath.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
    final imagesDir = await _imagesDirectory;
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