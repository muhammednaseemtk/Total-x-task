import 'package:flutter/material.dart';

class LoginWelcomeTitle extends StatelessWidget {
  const LoginWelcomeTitle({super.key});

  @override
  Widget build(BuildContext context) {   
    return const Center(
      child: Text(
        'Welcome\nTOTAL-X',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 26, height: 1.25, fontWeight: FontWeight.w700, color: Color(0xFF006BB3)),
      ),
    );
  }
}
