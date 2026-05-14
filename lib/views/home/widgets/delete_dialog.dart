import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DeleteDialog extends StatelessWidget {
  final String name;
  final VoidCallback onConfirm;

  const DeleteDialog({super.key, required this.name, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete User'),
      content: Text('Are you sure you want to delete $name?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}