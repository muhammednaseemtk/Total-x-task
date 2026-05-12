import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/helpers.dart';
import '../../domain/entities/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const UserCard({super.key, required this.user, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                avatarWidget(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(Helpers.formatPhone(user.phone), style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      ageTag(),
                    ],
                  ),
                ),
                if (onDelete != null) IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.error), onPressed: onDelete),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget avatarWidget() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Helpers.getAvatarColor(user.name)),
      child: user.imageUrl != null && user.imageUrl!.isNotEmpty
          ? ClipOval(child: Image.network(user.imageUrl!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => initialsWidget()))
          : initialsWidget(),
    );
  }

  Widget initialsWidget() {
    return Center(child: Text(Helpers.getInitials(user.name), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.white)));
  }

  Widget ageTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: user.isOlder ? Colors.orange.withAlpha(26) : Colors.green.withAlpha(26), borderRadius: BorderRadius.circular(4)),
      child: Text('${user.age} yrs (${Helpers.formatAgeCategory(user.age)})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: user.isOlder ? Colors.orange[700] : Colors.green[700])),
    );
  }
}