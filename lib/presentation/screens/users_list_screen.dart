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
                  onSearchChanged: userCtrl.search,
                ),
                if (!userCtrl.isLoading && userCtrl.filteredUsers.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'User List',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                Expanded(
                  child: UsersListView(
                    onDeleteUser: (id, name) => deleteUser(context, id, name),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 35),
            child: FloatingActionButton(
              onPressed: () => showAddUserDialog(context),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  void showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AddUserScreen(
        onSave: (name, phone, age, imagePath) {
          if (name.isEmpty || phone.isEmpty || age <= 0) {
            Helpers.showSnackBar(context, 'Please fill all fields correctly', isError: true);
            return;
          }
          Navigator.pop(ctx);
          final userCtrl = context.read<UserController>();
          userCtrl.addUser(name: name, phone: phone, age: age, imagePath: imagePath);
          Helpers.showSnackBar(context, 'User added successfully');
        },
        onCancel: (name, phone, age, imagePath) {
          Navigator.pop(ctx);
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