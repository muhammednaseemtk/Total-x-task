import 'package:flutter/material.dart';

class BottomButtonWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const BottomButtonWidget({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

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
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF7D7D7D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onSave,
          child: Container(
            width: 95,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF257CEB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
