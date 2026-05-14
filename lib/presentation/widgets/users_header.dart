import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class UsersHeader extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onFilter;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  const UsersHeader({
    super.key,
    required this.onLogout,
    required this.onFilter,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationHeader(location: 'Nilambur', onLogout: onLogout),
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.background,
          child: CustomSearchFilterBar(
            onFilter: onFilter,
            searchController: searchController,
            onSearchChanged: onSearchChanged,
          ),
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

class CustomSearchFilterBar extends StatelessWidget {
  final VoidCallback onFilter;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  const CustomSearchFilterBar({
    super.key,
    required this.onFilter,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              cursorColor: Colors.black,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF444444),
              ),
              decoration: InputDecoration(
                hintText: 'search by name',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9E9E9E),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 30,
                  color: Color(0xFF555555),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFB8B8B8),
                    width: 1.2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFB8B8B8),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFB8B8B8),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onFilter,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 14,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 10,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
