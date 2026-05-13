import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class UsersHeader extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onFilter;
  final TextEditingController searchController;
  final VoidCallback onClearSearch;

  const UsersHeader({super.key, required this.onLogout, required this.onFilter, required this.searchController, required this.onClearSearch});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LocationHeader(location: 'Nilambur', onLogout: onLogout),
      SearchFilterBar(onFilter: onFilter, searchController: searchController, onClearSearch: onClearSearch),
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

class SearchFilterBar extends StatefulWidget {
  final VoidCallback onFilter;
  final TextEditingController searchController;
  final VoidCallback onClearSearch;

  const SearchFilterBar({super.key, required this.onFilter, required this.searchController, required this.onClearSearch});

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

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
              child: TextField(
                controller: widget.searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name or phone',
                  hintStyle: const TextStyle(color: AppColors.grey),
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                  suffixIcon: widget.searchController.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear, color: AppColors.grey), onPressed: widget.onClearSearch)
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
            child: IconButton(icon: const Icon(Icons.filter_list), onPressed: widget.onFilter),
          ),
        ],
      ),
    );
  }
}
