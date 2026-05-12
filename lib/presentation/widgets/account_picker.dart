import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/constants/color_constants.dart';

class AccountPickerSheet extends StatelessWidget {
  final List<GoogleSignInAccount> accounts;
  final Function(GoogleSignInAccount) onAccountSelected;
  final VoidCallback onAddAnother;

  const AccountPickerSheet({
    super.key,
    required this.accounts,
    required this.onAccountSelected,
    required this.onAddAnother,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(77),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...accounts.map(
            (account) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                backgroundImage: account.photoUrl != null
                    ? NetworkImage(account.photoUrl!)
                    : null,
                child: account.photoUrl == null
                    ? Text(
                        account.displayName?.substring(0, 1).toUpperCase() ??
                            '?',
                        style: const TextStyle(color: AppColors.white),
                      )
                    : null,
              ),
              title: Text(
                account.displayName ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                account.email,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              onTap: () => onAccountSelected(account),
            ),
          ),
          const Divider(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grey.withAlpha(77)),
              ),
              child: const Icon(Icons.add, color: AppColors.grey),
            ),
            title: const Text(
              'Add Another Account',
              style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
            onTap: onAddAnother,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
