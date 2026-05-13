import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/image_controller.dart';

class AddUserDialog extends StatelessWidget {
  final Function(String, String, int, String?) onSubmit;
  const AddUserDialog({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageControllerUtil(),
      child: _AddUserDialogContent(onSubmit: onSubmit),
    );
  }
}

class _AddUserDialogContent extends StatelessWidget {
  final Function(String, String, int, String?) onSubmit;
  const _AddUserDialogContent({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add New User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 24),
              const _ImagePicker(),
              const SizedBox(height: 20),
              _Form(onSubmit: onSubmit),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  const _ImagePicker();

  @override
  Widget build(BuildContext context) {
    final img = context.watch<ImageControllerUtil>();
    return GestureDetector(
      onTap: () => _pick(context),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.lightGrey, border: Border.all(color: AppColors.divider, width: 2)),
        child: img.imagePath != null
            ? ClipOval(child: Image.file(File(img.imagePath!), fit: BoxFit.cover, width: 100, height: 100))
            : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.camera_alt, color: AppColors.grey, size: 32),
                SizedBox(height: 4),
                Text('Add Photo', style: TextStyle(fontSize: 12, color: AppColors.grey)),
              ]),
      ),
    );
  }

  void _pick(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(ctx);
                await context.read<ImageControllerUtil>().pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(ctx);
                await context.read<ImageControllerUtil>().pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final Function(String, String, int, String?) onSubmit;
  const _Form({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return _AddUserForm(onSubmit: onSubmit);
  }
}

class _AddUserForm extends StatefulWidget {
  final Function(String, String, int, String?) onSubmit;
  const _AddUserForm({required this.onSubmit});

  @override
  State<_AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<_AddUserForm> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _age = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _age.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.isNotEmpty && _phone.text.isNotEmpty && _age.text.isNotEmpty) {
      final img = context.read<ImageControllerUtil>();
      Navigator.pop(context);
      widget.onSubmit(_name.text.trim(), _phone.text.trim(), int.parse(_age.text.trim()), img.imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline))),
        const SizedBox(height: 16),
        TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)), keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        TextField(controller: _age, decoration: const InputDecoration(labelText: 'Age', prefixIcon: Icon(Icons.cake_outlined)), keyboardType: TextInputType.number),
        const SizedBox(height: 24),
        Row(
          children: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            const SizedBox(width: 16),
            Expanded(child: ElevatedButton(onPressed: _submit, child: const Text('Save'))),
          ],
        ),
      ],
    );
  }
}
