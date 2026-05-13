import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/helpers.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/users_header.dart';
import '../widgets/users_sort_sheet.dart';
import '../widgets/users_sign_out_dialog.dart';
import '../widgets/users_list_view.dart';
import 'login_screen.dart';
import 'add_user_screen.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userCtrl, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                UsersHeader(
                  onLogout: () => signOutWithAuth(context),
                  onFilter: () => showSortSheet(context, userCtrl),
                  searchController: userCtrl.searchController,
                  onClearSearch: userCtrl.clearSearch,
                  onSearchChanged: userCtrl.search,
                ),
                Expanded(
                  child: UsersListView(
                    onDeleteUser: (id, name) => deleteUser(context, id, name),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showAddUserDialog(context),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            icon: const Icon(Icons.person_add),
            label: const Text('Add User'),
          ),
        );
      },
    );
  }

  void showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AddUserScreen(
        onSave: () {
          Navigator.pop(ctx);
          final userCtrl = context.read<UserController>();
          userCtrl.addUser(name: 'Sam Curren', phone: '+91 9876543210', age: 43, imagePath: null);
          Helpers.showSnackBar(context, 'User added successfully');
        },
      ),
    );
  }

  void showSortSheet(BuildContext context, UserController userCtrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => UsersSortSheet(
        currentSort: userCtrl.sortType,
        onSortChanged: userCtrl.setSortType,
      ),
    );
  }

  void deleteUser(BuildContext context, String id, String name) async {
    final userCtrl = context.read<UserController>();
    final success = await userCtrl.deleteUser(id);
    if (context.mounted) {
      Helpers.showSnackBar(
        context,
        success ? 'User deleted' : 'Failed to delete user',
        isError: !success,
      );
    }
  }

  void signOutWithAuth(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => const UsersSignOutDialog(),
    );
    if (confirmed == true && context.mounted) {
      final authCtrl = context.read<AuthController>();
      await authCtrl.signOut();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }
}