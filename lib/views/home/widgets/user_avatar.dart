import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';

class UserAvatar extends StatelessWidget {
  final String name;

  const UserAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final color = Helpers.getAvatarColor(name.isNotEmpty ? name : 'User');
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: Text(
          Helpers.getInitials(name),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
