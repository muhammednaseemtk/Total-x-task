import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/image_controller.dart';

class AddUserDialog extends StatelessWidget {
  final Function(String, String, int, String?) onSubmit;

  const AddUserDialog({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: const _AddUserDialogContent(onSubmit: null),
    );
  }
}

class _AddUserDialogContent extends StatefulWidget {
  final Function(String, String, int, String?)? onSubmit;

  const _AddUserDialogContent({required this.onSubmit});

  @override
  State<_AddUserDialogContent> createState() => _AddUserDialogContentState();
}

class _AddUserDialogContentState extends State<_AddUserDialogContent> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  String? imagePath;

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }

  void submit() {
    if (nameCtrl.text.isNotEmpty &&
        phoneCtrl.text.isNotEmpty &&
        ageCtrl.text.isNotEmpty) {
      widget.onSubmit?.call(
        nameCtrl.text.trim(),
        phoneCtrl.text.trim(),
        int.parse(ageCtrl.text.trim()),
        imagePath,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.photo_library,
                          color: AppColors.primary,
                        ),
                        title: const Text('Choose from Gallery'),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final ctrl = ImageControllerUtil();
                          await ctrl.pickImageFromGallery();
                          if (ctrl.imagePath != null)
                            setState(() => imagePath = ctrl.imagePath);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.camera_alt,
                          color: AppColors.primary,
                        ),
                        title: const Text('Take a Photo'),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final ctrl = ImageControllerUtil();
                          await ctrl.pickImageFromCamera();
                          if (ctrl.imagePath != null)
                            setState(() => imagePath = ctrl.imagePath);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightGrey,
                  border: Border.all(color: AppColors.divider, width: 2),
                ),
                child: imagePath != null
                    ? ClipOval(
                        child: Image.file(
                          File(imagePath!),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: AppColors.grey,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add Photo',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey.withAlpha(179),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ageCtrl,
              decoration: const InputDecoration(
                labelText: 'Age',
                prefixIcon: Icon(Icons.cake_outlined),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: submit,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
