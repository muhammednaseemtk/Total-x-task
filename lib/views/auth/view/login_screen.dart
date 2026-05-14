import 'package:flutter/material.dart';
import '../widgets/login_header_text.dart';
import '../widgets/login_welcome_title.dart';
import '../widgets/login_google_button.dart';
import '../widgets/login_terms_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                const LoginHeaderText(),
                const SizedBox(height: 50),
                const LoginWelcomeTitle(),
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 340,
                    height: 340,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/payement.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Center(child: LoginGoogleButton()),
                const SizedBox(height: 18),
                const LoginTermsText(),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
