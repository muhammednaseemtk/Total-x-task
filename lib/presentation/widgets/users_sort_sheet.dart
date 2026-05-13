import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';
import '../controllers/user_controller.dart';

class UsersSortSheet extends StatelessWidget {
  final SortType currentSort;
  final Function(SortType) onSortChanged;

  const UsersSortSheet({super.key, required this.currentSort, required this.onSortChanged});

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
          ...SortType.values.map((type) => Column(children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    type == SortType.all ? 'All Users' : type == SortType.above60 ? 'Age: Above 60 (Older)' : 'Age: Below 60 (Younger)',
                    style: TextStyle(fontSize: 16, color: currentSort == type ? AppColors.primary : AppColors.textPrimary, fontWeight: currentSort == type ? FontWeight.w600 : FontWeight.normal),
                  ),
                  trailing: currentSort == type ? const Icon(Icons.check_circle, color: AppColors.primary) : Icon(Icons.circle_outlined, color: AppColors.grey.withAlpha(77)),
                  onTap: () {
                    onSortChanged(type);
                    Navigator.pop(context);
                  },
                ),
                if (type != SortType.below60) const Divider(height: 1),
              ])),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
