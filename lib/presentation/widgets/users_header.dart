import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class UsersHeader extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onFilter;

  const UsersHeader({super.key, required this.onLogout, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LocationHeader(location: 'Nilambur', onLogout: onLogout),
      SearchFilterBar(onFilter: onFilter),
    ]);
  }
}

class LocationHeader extends StatelessWidget {
  final String location;
  final VoidCallback onLogout;

  const LocationHeader({super.key, required this.location, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.primary,
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.white, size: 20),
          const SizedBox(width: 8),
          Text(location, style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.logout, color: AppColors.white), onPressed: onLogout),
        ],
      ),
    );
  }
}

class SearchFilterBar extends StatelessWidget {
  final VoidCallback onFilter;

  const SearchFilterBar({super.key, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.background,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name or phone',
                  hintStyle: TextStyle(color: AppColors.grey),
                  prefixIcon: Icon(Icons.search, color: AppColors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
            child: IconButton(icon: const Icon(Icons.filter_list), onPressed: onFilter),
          ),
        ],
      ),
    );
  }
}
