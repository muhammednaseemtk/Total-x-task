import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ImageSourceType { gallery, camera }

class ImageControllerUtil extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();

  String? imagePath;
  bool isUploading = false;
  String? errorMessage;

  String? get imagePathValue => imagePath;
  bool get isUploadingValue => isUploading;
  String? get errorMessageValue => errorMessage;

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        imagePath = image.path;
        errorMessage = null;
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to pick image from gallery';
      notifyListeners();
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        imagePath = image.path;
        errorMessage = null;
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to capture image from camera';
      notifyListeners();
    }
  }

  void setImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }

  void setUploading(bool uploading) {
    isUploading = uploading;
    notifyListeners();
  }

  void clearImage() {
    imagePath = null;
    errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
