import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class UserNoSearchResultsState extends StatelessWidget {
  const UserNoSearchResultsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.grey),
          SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
          SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
