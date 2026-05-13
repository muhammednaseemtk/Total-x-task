import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../controllers/auth_controller.dart';
import '../screens/users_list_screen.dart';

class LoginGoogleButton extends StatelessWidget {
  const LoginGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, child) {
        return SizedBox(
          width: 320,
          height: 50,
          child: SignInButton(
            Buttons.google,
            text: "Continue with Google",

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.black26, 
                width: 1.5,
              ),
            ),

            elevation: 0,
            padding: const EdgeInsets.all(0),
            onPressed: () async {
              if (auth.isLoading) return;

              final success = await auth.signInWithGoogle();

              if (success && context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UsersListScreen(),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}