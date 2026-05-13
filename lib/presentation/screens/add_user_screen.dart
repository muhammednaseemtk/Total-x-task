import 'package:flutter/material.dart';

class AddUserScreen extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  const AddUserScreen({
    super.key,
    this.onCancel,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: AddUserTitleWidget(),
              ),
              const SizedBox(height: 28),
              const Center(
                child: ProfileImageWidget(),
              ),
              const SizedBox(height: 34),
              const LabelTextWidget(title: 'Name'),
              const SizedBox(height: 12),
              const CustomTextFieldWidget(
                hintText: 'Sam Curren',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 26),
              const LabelTextWidget(title: 'Age'),
              const SizedBox(height: 12),
              const CustomTextFieldWidget(
                hintText: '43',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 26),
              const LabelTextWidget(title: 'Phone Number'),
              const SizedBox(height: 12),
              const CustomTextFieldWidget(
                hintText: '+91 9876543210',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 26),
              BottomButtonWidget(
                onCancel: onCancel ?? () => Navigator.pop(context),
                onSave: onSave ?? () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
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
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0BB2F5),
                  Color(0xFF365AE8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 30,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFD9E1EA),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 76,
            child: Container(
              width: 84,
              height: 58,
              decoration: const BoxDecoration(
                color: Color(0xFFD9E1EA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 26,
            child: Container(
              width: 165,
              height: 46,
              decoration: const BoxDecoration(
                color: Color(0xFF1D4A8F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                  bottomRight: Radius.circular(90),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 34,
            child: Container(
              width: 38,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
            ),
          ),
        ],
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

  const CustomTextFieldWidget({
    super.key,
    required this.hintText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 18, color: Color(0xFF3B3B3B), fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 18, color: Color(0xFF3B3B3B), fontWeight: FontWeight.w500),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD1D1D1), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
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
            width: 102,
            height: 52,
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
            width: 102,
            height: 52,
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