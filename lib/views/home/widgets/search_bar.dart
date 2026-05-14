import 'package:flutter/material.dart';
import 'package:totalx_task/views/home/widgets/custom_search_filter_bar.dart';
import 'package:totalx_task/views/home/widgets/location_header.dart';
import '../../../core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onFilter;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  const HomeHeader({
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
