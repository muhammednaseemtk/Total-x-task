import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class UserEmptyState extends StatelessWidget {
  const UserEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: AppColors.grey),
          SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first user by tapping the button below',
            style: TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
