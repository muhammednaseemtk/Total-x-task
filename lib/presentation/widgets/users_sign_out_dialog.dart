import 'package:flutter/material.dart';

class UsersSignOutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const UsersSignOutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
