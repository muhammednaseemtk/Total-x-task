import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/image_controller.dart';
import '../widgets/add_user_bottom_buttons.dart';
import '../widgets/add_user_label_text.dart';
import '../widgets/add_user_profile_image.dart';
import '../widgets/add_user_text_field.dart';
import '../widgets/add_user_title.dart';

class AddUserScreen extends StatelessWidget {
  final void Function(String name, String phone, int age, String? imagePath)?
  onCancel;
  final void Function(String name, String phone, int age, String? imagePath)?
  onSave;

  AddUserScreen({super.key, this.onCancel, this.onSave});

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageController>(
      builder: (context, imageController, child) {
        return Dialog(
          backgroundColor: const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
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
                      const Center(child: AddUserTitleWidget()),
                      const SizedBox(height: 20),

                      const Center(child: ProfileImageWidget()),
                      const SizedBox(height: 20),

                      const LabelTextWidget(title: 'Name'),
                      const SizedBox(height: 8),

                      CustomTextFieldWidget(
                        hintText: 'Sam Curren',
                        keyboardType: TextInputType.name,
                        controller: nameController,
                      ),

                      const SizedBox(height: 14),

                      const LabelTextWidget(title: 'Age'),
                      const SizedBox(height: 8),

                      CustomTextFieldWidget(
                        hintText: '43',
                        keyboardType: TextInputType.number,
                        controller: ageController,
                      ),

                      const SizedBox(height: 14),

                      const LabelTextWidget(title: 'Phone Number'),
                      const SizedBox(height: 8),

                      CustomTextFieldWidget(
                        hintText: '+91 9876543210',
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                      ),

                      const SizedBox(height: 14),

                      BottomButtonWidget(
                        onCancel: () {
                          imageController.clearImage();
                          nameController.clear();
                          ageController.clear();
                          phoneController.clear();

                          onCancel?.call('', '', 0, null);
                        },
                        onSave: () {
                          final name = nameController.text.trim();
                          final phone = phoneController.text.trim();
                          final ageText = ageController.text.trim();
                          final age = int.tryParse(ageText) ?? 0;
                          final imagePath = imageController.imagePath;

                          onSave?.call(name, phone, age, imagePath);

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
