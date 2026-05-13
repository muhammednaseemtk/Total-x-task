import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';
import '../controllers/user_controller.dart';

class SortSheet extends StatelessWidget {
  final SortType currentSort;
  final Function(SortType) onSortChanged;

  const SortSheet({super.key, required this.currentSort, required this.onSortChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey.withAlpha(77), borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          const Text('Sort By Age', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          sortOption('All Users', SortType.all, context),
          const Divider(height: 1),
          sortOption('Age: Above 25', SortType.above25, context),
          const Divider(height: 1),
          sortOption('Age: Below 25', SortType.below25, context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget sortOption(String title, SortType type, BuildContext context) {
    final isSelected = currentSort == type;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontSize: 16, color: isSelected ? AppColors.primary : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : Icon(Icons.circle_outlined, color: AppColors.grey.withAlpha(77)),
      onTap: () {
        onSortChanged(type);
        Navigator.pop(context);
      },
    );
  }
}