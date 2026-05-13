import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/helpers.dart';
import '../controllers/user_controller.dart';
import 'users_delete_dialog.dart';

class UsersListView extends StatefulWidget {
  final Function(String, String) onDeleteUser;

  const UsersListView({super.key, required this.onDeleteUser});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<UserController>().loadUsers());
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<UserController>().loadMoreUsers();
    }
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userCtrl, child) {
        if (userCtrl.isLoading && userCtrl.users.isEmpty) return const Center(child: CircularProgressIndicator());
        if (userCtrl.errorMessage != null && userCtrl.users.isEmpty) return _ErrorState(message: userCtrl.errorMessage!, onRetry: () => userCtrl.loadUsers(refresh: true));
        if (userCtrl.users.isEmpty) return const _EmptyState();

        return RefreshIndicator(
          onRefresh: () => userCtrl.loadUsers(refresh: true),
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.all(16),
            itemCount: userCtrl.users.length + (userCtrl.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == userCtrl.users.length) return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
              final user = userCtrl.users[index];
              return UserListItem(
                user: user,
                onDelete: () => _confirmDelete(context, user.id, user.name),
              );
            },
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => UsersDeleteDialog(name: name, onConfirm: () => widget.onDeleteUser(id, name)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: AppColors.grey),
          SizedBox(height: 16),
          Text('No users found', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
          SizedBox(height: 8),
          Text('Add your first user by tapping the button below', style: TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.grey),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final dynamic user;
  final VoidCallback? onDelete;

  const UserListItem({super.key, required this.user, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _UserAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(Helpers.formatPhone(user.phone), style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      _AgeTag(age: user.age),
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
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Helpers.getAvatarColor(context.read<UserController>().users.isNotEmpty ? 'User' : 'User');
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: Text(Helpers.getInitials('User'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.white)),
      ),
    );
  }
}

class _AgeTag extends StatelessWidget {
  final int age;
  const _AgeTag({required this.age});

  @override
  Widget build(BuildContext context) {
    final isOlder = age > 60;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: isOlder ? Colors.orange.withAlpha(26) : Colors.green.withAlpha(26), borderRadius: BorderRadius.circular(4)),
      child: Text('$age yrs (${isOlder ? 'Older' : 'Younger'})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isOlder ? Colors.orange[700] : Colors.green[700])),
    );
  }
}
