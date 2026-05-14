import 'package:flutter/material.dart';
import 'package:totalx_task/core/constants/app_colors.dart';

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