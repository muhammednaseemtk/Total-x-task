import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../core/constants/color_constants.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_widgets.dart';
import 'users_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().loadAvailableAccounts();
    });
  }

  void navigateToUsersList() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UsersListScreen()));
  }

  void showAccountPicker(List<GoogleSignInAccount> accounts, AuthController auth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHandle(),
            const SizedBox(height: 20),
            const Text('Choose Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ...accounts.map((account) => AccountTileItem(
                  account: account,
                  onTap: () async {
                    Navigator.pop(ctx);
                    await auth.selectAccount(account);
                    if (auth.isLoggedIn) navigateToUsersList();
                  },
                )),
            const Divider(height: 32),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.grey.withAlpha(77))), child: const Icon(Icons.add, color: AppColors.grey)),
              title: const Text('Add Another Account', style: TextStyle(fontSize: 16, color: AppColors.textPrimary)),
              onTap: () async {
                Navigator.pop(ctx);
                await auth.addAnotherAccount();
                await auth.signInWithGoogle();
                if (auth.isLoggedIn) navigateToUsersList();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void handleGoogleSignIn(AuthController auth) async {
    if (auth.availableAccounts.isNotEmpty) {
      showAccountPicker(auth.availableAccounts, auth);
    } else {
      final success = await auth.signInWithGoogle();
      if (success) navigateToUsersList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Consumer<AuthController>(
          builder: (context, auth, child) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                const Spacer(),
                const AppLogo(),
                const SizedBox(height: 40),
                const WelcomeTitle(),
                const Spacer(),
                auth.availableAccounts.isNotEmpty
                    ? AccountList(
                        accounts: auth.availableAccounts,
                        onSelect: (account) async {
                          await auth.selectAccount(account);
                          if (auth.isLoggedIn) navigateToUsersList();
                        },
                        onAddAnother: () async {
                          await auth.addAnotherAccount();
                          if (auth.availableAccounts.isNotEmpty) {
                            showAccountPicker(auth.availableAccounts, auth);
                          } else {
                            final success = await auth.signInWithGoogle();
                            if (success) navigateToUsersList();
                          }
                        },
                      )
                    : GoogleButton(isLoading: auth.isLoading, onPressed: () => handleGoogleSignIn(auth)),
                const SizedBox(height: 24),
                const TermsText(),
                const SizedBox(height: 32),
              ]),
            );
          },
        ),
      ),
    );
  }
}