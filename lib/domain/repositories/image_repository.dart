abstract class ImageRepository {
  Future<String?> pickImageFromGallery();
  Future<String?> pickImageFromCamera();
  Future<String> saveImage(String sourcePath);
  Future<void> deleteImage(String imagePath);
  bool imageExists(String? imagePath);
}