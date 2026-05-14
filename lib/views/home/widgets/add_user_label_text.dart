import 'package:flutter/material.dart';

class LabelTextWidget extends StatelessWidget {
  final String title;

  const LabelTextWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF8C8C8C),
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
