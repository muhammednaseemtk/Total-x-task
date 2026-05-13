import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';
import '../../domain/entities/user.dart';
import '../../core/utils/helpers.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 64,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, color: AppColors.primary, size: 32),
            SizedBox(width: 8),
            Icon(Icons.monetization_on, color: Colors.amber, size: 32),
            SizedBox(width: 8),
            Icon(Icons.verified, color: AppColors.success, size: 32),
          ],
        ),
      ],
    );
  }
}

class WelcomeTitle extends StatelessWidget {
  const WelcomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Welcome to',
          style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
        ),
        SizedBox(height: 8),
        Text(
          'TOTAL-X',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Sign in to manage users\nand access your dashboard',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'By continuing, you agree to our\nTerms of Service and Privacy Policy',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, color: AppColors.grey, height: 1.5),
    );
  }
}

class GoogleButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const GoogleButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.divider),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.g_mobiledata, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }
}

class AccountTileItem extends StatelessWidget {
  final GoogleSignInAccount account;
  final VoidCallback onTap;

  const AccountTileItem({
    super.key,
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          backgroundImage: account.photoUrl != null
              ? NetworkImage(account.photoUrl!)
              : null,
          child: account.photoUrl == null
              ? Text(
                  account.displayName?.substring(0, 1).toUpperCase() ?? '?',
                  style: const TextStyle(color: AppColors.white),
                )
              : null,
        ),
        title: Text(account.displayName ?? 'Unknown'),
        subtitle: Text(account.email),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class AccountList extends StatelessWidget {
  final List<GoogleSignInAccount> accounts;
  final Function(GoogleSignInAccount) onSelect;
  final VoidCallback onAddAnother;

  const AccountList({
    super.key,
    required this.accounts,
    required this.onSelect,
    required this.onAddAnother,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...accounts.map(
          (account) =>
              AccountTileItem(account: account, onTap: () => onSelect(account)),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onAddAnother,
          child: const Text('Sign in with a different account'),
        ),
      ],
    );
  }
}

class LocationHeader extends StatelessWidget {
  final String location;
  final VoidCallback onLogout;

  const LocationHeader({
    super.key,
    required this.location,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.primary,
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            location,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}

class SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback onClear;
  final VoidCallback onFilter;

  const SearchFilterBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.background,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                controller: controller,
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: 'Search by name or phone',
                  hintStyle: const TextStyle(color: AppColors.grey),
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.grey),
                          onPressed: onClear,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: onFilter,
            ),
          ),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final User user;
  final double size;

  const UserAvatar({super.key, required this.user, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Helpers.getAvatarColor(user.name),
      ),
      child: user.imageUrl != null && user.imageUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                user.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => initialsWidget(),
              ),
            )
          : initialsWidget(),
    );
  }

  Widget initialsWidget() {
    return Center(
      child: Text(
        Helpers.getInitials(user.name),
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class AgeTagBadge extends StatelessWidget {
  final User user;

  const AgeTagBadge({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: user.isOlder
            ? Colors.orange.withAlpha(26)
            : Colors.green.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${user.age} yrs (${Helpers.formatAgeCategory(user.age)})',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: user.isOlder ? Colors.orange[700] : Colors.green[700],
        ),
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback? onDelete;

  const UserListItem({super.key, required this.user, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                UserAvatar(user: user),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Helpers.formatPhone(user.phone),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AgeTagBadge(user: user),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyStateView({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.people_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.grey.withAlpha(128)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }
}

class ErrorStateView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.grey),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.grey.withAlpha(77),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class SortOptionItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SortOptionItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : Icon(Icons.circle_outlined, color: AppColors.grey.withAlpha(77)),
      onTap: onTap,
    );
  }
}

class ImagePickerCircle extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const ImagePickerCircle({super.key, this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.lightGrey,
          border: Border.all(color: AppColors.divider, width: 2),
        ),
        child: imagePath != null
            ? ClipOval(
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, color: AppColors.grey, size: 32),
                  const SizedBox(height: 4),
                  Text(
                    'Add Photo',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey.withAlpha(179),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const FormTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return isOutlined
        ? TextButton(onPressed: onPressed, child: Text(text))
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(text),
          );
  }
}
