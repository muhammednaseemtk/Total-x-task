import 'package:flutter/material.dart';

class LoginTermsText extends StatelessWidget {
  const LoginTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF7D7D7D),
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(text: "By Continuing, I agree to TotalX's "),
          TextSpan(
            text: 'Terms and condition',
            style: TextStyle(
              color: Color(0xFF7FA8FF),
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: ' &\n'),
          TextSpan(
            text: 'privacy policy',
            style: TextStyle(
              color: Color(0xFF7FA8FF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
