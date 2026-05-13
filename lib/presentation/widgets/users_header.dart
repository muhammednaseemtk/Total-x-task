import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class UsersHeader extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onFilter;
  final TextEditingController searchController;
  final VoidCallback onClearSearch;
  final Function(String) onSearchChanged;

  const UsersHeader({
    super.key,
    required this.onLogout,
    required this.onFilter,
    required this.searchController,
    required this.onClearSearch,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LocationHeader(location: 'Nilambur', onLogout: onLogout),
      SearchFilterBar(
        onFilter: onFilter,
        searchController: searchController,
        onClearSearch: onClearSearch,
        onSearchChanged: onSearchChanged,
      ),
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
  final Function(String) onSearchChanged;

  const SearchFilterBar({
    super.key,
    required this.onFilter,
    required this.searchController,
    required this.onClearSearch,
    required this.onSearchChanged,
  });

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
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFFB8B8B8),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  const Icon(
                    Icons.search,
                    size: 28,
                    color: Color(0xFF505050),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: widget.searchController,
                      onChanged: widget.onSearchChanged,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF404040),
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'search by name',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        isCollapsed: true,
                        suffixIcon: widget.searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: widget.onClearSearch,
                                child: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Color(0xFF505050),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: widget.onFilter,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}
