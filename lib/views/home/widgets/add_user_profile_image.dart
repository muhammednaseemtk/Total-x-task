import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/image_controller.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageController>(
      builder: (context, imageController, child) {
        return GestureDetector(
          onTap: () => _showImagePickerSheet(context, imageController),
          child: SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (imageController.imagePath != null)
                  ClipOval(
                    child: Image.file(
                      File(imageController.imagePath!),
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF0BB2F5), Color(0xFF365AE8)],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 26,
                  child: Container(
                    width: 32,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImagePickerSheet(
    BuildContext context,
    ImageController imageController,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                imageController.pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                imageController.pickImageFromCamera();
              },
            ),
            if (imageController.imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  imageController.clearImage();
                },
              ),
          ],
        ),
      ),
    );
  }
}
