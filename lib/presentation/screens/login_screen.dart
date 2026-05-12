import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/color_constants.dart';
import '../controllers/auth_controller.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              const HeaderTextWidget(),
              const SizedBox(height: 70),
              const WelcomeTitleWidget(),
              const SizedBox(height: 40),
              const Center(child: IllustrationWidget()),
              const Spacer(),
              const GoogleButtonWidget(),
              const SizedBox(height: 18),
              const TermsTextWidget(),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderTextWidget extends StatelessWidget {
  const HeaderTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Login or create an Account',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }
}

class WelcomeTitleWidget extends StatelessWidget {
  const WelcomeTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Welcome\nTOTAL-X',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: Color(0xFF006BB3),
        ),
      ),
    );
  }
}

class IllustrationWidget extends StatelessWidget {
  const IllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 230,
            width: 260,
            decoration: BoxDecoration(
              color: const Color(0xFFBFE5FF),
              borderRadius: BorderRadius.circular(70),
            ),
          ),
          Positioned(
            left: 35,
            top: 70,
            child: Column(
              children: [
                const CheckCircleWidget(),
                const SizedBox(height: 12),
                const CheckCircleWidget(),
                const SizedBox(height: 12),
                Container(
                  width: 35,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      7,
                      (index) => Container(
                        width: 18,
                        height: 3,
                        color: const Color(0xFF0A5D9A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 35,
            top: 90,
            child: Column(
              children: const [
                CoinWidget(),
                SizedBox(height: 18),
                CoinWidget(),
                SizedBox(height: 18),
                CoinWidget(),
              ],
            ),
          ),
          Positioned(
            bottom: 18,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 165,
                  decoration: BoxDecoration(
                    color: const Color(0xFF004A8F),
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                Positioned(
                  left: 8,
                  child: Container(
                    width: 110,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0069A8),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    width: 92,
                    height: 135,
                    decoration: BoxDecoration(
                      color: const Color(0xFF12D5E4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          width: 36,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEDEDED),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF006BB3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  child: Column(
                    children: [
                      Container(width: 62, height: 5, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(width: 45, height: 4, color: Colors.white),
                    ],
                  ),
                ),
                Positioned(
                  right: -45,
                  child: Container(
                    width: 110,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2440),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 18,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC22E),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 25,
                          child: Row(
                            children: List.generate(
                              3,
                              (index) => Container(
                                margin: const EdgeInsets.only(right: 4),
                                width: 16,
                                height: 4,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckCircleWidget extends StatelessWidget {
  const CheckCircleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFF09A9D8),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 18),
    );
  }
}

class CoinWidget extends StatelessWidget {
  const CoinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFFFD45A),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '\$',
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class GoogleButtonWidget extends StatelessWidget {
  const GoogleButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, child) {
        return GestureDetector(
          onTap: () async {
            final success = await auth.signInWithGoogle();
            if (success && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDADADA)),
            ),
            child: auth.isLoading
                ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue With Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class TermsTextWidget extends StatelessWidget {
  const TermsTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF7D7D7D),
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(text: 'By Continuing, I agree to TotalX\'s '),
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
