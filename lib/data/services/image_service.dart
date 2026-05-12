import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Reference get imagesRef => storage.ref('user_images');

  Future<String> uploadImage(String localPath, String userId) async {
    final File file = File(localPath);
    if (!await file.exists()) {
      throw Exception('Image file not found');
    }

    final String extension = localPath.split('.').last;
    final String fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final Reference ref = imagesRef.child(fileName);

    await ref.putFile(file);

    final String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteImage(String imageUrl) async {
    if (imageUrl.isEmpty) return;
    try {
      final Reference ref = storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Ignore deletion errors
    }
  }

  Future<String> getImageUrl(String userId) async {
    final ListResult result = await imagesRef.list();
    final files = result.items.where((ref) => ref.name.startsWith(userId));
    if (files.isNotEmpty) {
      return await files.first.getDownloadURL();
    }
    return '';
  }
}