import 'package:flutter/material.dart';

class UserAgeTag extends StatelessWidget {
  final int age;

  const UserAgeTag({super.key, required this.age});

  @override
  Widget build(BuildContext context) {
    final isOlder = age > 60;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isOlder
            ? Colors.orange.withAlpha(26)
            : Colors.green.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Age: $age',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isOlder ? Colors.orange[700] : Colors.green[700],
        ),
      ),
    );
  }
}
