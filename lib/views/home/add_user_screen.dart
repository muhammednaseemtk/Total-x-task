import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/image_controller.dart';
import 'dart:io';

class AddUserScreen extends StatefulWidget {
  final void Function(String name, String phone, int age, String? imagePath)? onCancel;
  final void Function(String name, String phone, int age, String? imagePath)? onSave;

  const AddUserScreen({
    super.key,
    this.onCancel,
    this.onSave,
  });

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageController>(
      builder: (context, imageController, child) {
        return Dialog(
          backgroundColor: const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: AddUserTitleWidget(),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: ProfileImageWidget(),
                      ),
                      const SizedBox(height: 20),
                      const LabelTextWidget(title: 'Name'),
                      const SizedBox(height: 8),
                      CustomTextFieldWidget(
                        hintText: 'Sam Curren',
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 14),
                      const LabelTextWidget(title: 'Age'),
                      const SizedBox(height: 8),
                      CustomTextFieldWidget(
                        hintText: '43',
                        keyboardType: TextInputType.number,
                        controller: _ageController,
                      ),
                      const SizedBox(height: 14),
                      const LabelTextWidget(title: 'Phone Number'),
                      const SizedBox(height: 8),
                      CustomTextFieldWidget(
                        hintText: '+91 9876543210',
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                      ),
                      const SizedBox(height: 14),
                      BottomButtonWidget(
                        onCancel: () {
                          imageController.clearImage();
                          _nameController.clear();
                          _ageController.clear();
                          _phoneController.clear();
                          widget.onCancel?.call('', '', 0, null);
                        },
                        onSave: () {
                          final name = _nameController.text.trim();
                          final phone = _phoneController.text.trim();
                          final ageText = _ageController.text.trim();
                          final age = int.tryParse(ageText) ?? 0;
                          final imagePath = imageController.imagePath;
                          
                          widget.onSave?.call(name, phone, age, imagePath);
                          imageController.clearImage();
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AddUserTitleWidget extends StatelessWidget {
  const AddUserTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Add A New User',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}

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
                    child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImagePickerSheet(BuildContext context, ImageController imageController) {
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
                title: const Text('Remove', style: TextStyle(color: Colors.red)),
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

class LabelTextWidget extends StatelessWidget {
  final String title;
  const LabelTextWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, color: Color(0xFF8C8C8C), fontWeight: FontWeight.w400),
    );
  }
}

class CustomTextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const CustomTextFieldWidget({
    super.key,
    required this.hintText,
    required this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Color(0xFF3B3B3B), fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 16, color: Color(0xFF3B3B3B), fontWeight: FontWeight.w500),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD1D1D1), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2B7DE9), width: 2),
          ),
        ),
      ),
    );
  }
}

class BottomButtonWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const BottomButtonWidget({super.key, required this.onCancel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onCancel,
          child: Container(
            width: 95,
            height: 48,
            decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(16)),
            child: const Center(
              child: Text('Cancel', style: TextStyle(fontSize: 18, color: Color(0xFF7D7D7D), fontWeight: FontWeight.w500)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onSave,
          child: Container(
            width: 95,
            height: 48,
            decoration: BoxDecoration(color: const Color(0xFF257CEB), borderRadius: BorderRadius.circular(16)),
            child: const Center(
              child: Text('Save', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }
}