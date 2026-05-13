import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/helpers.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/add_user_dialog.dart';
import '../widgets/users_header.dart';
import '../widgets/users_sort_sheet.dart';
import '../widgets/users_sign_out_dialog.dart';
import '../widgets/users_list_view.dart';
import 'login_screen.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          UsersHeader(onLogout: () => _signOut(context), onFilter: () => _showSortSheet(context)),
          Expanded(child: UsersListView(onDeleteUser: (id, name) => _deleteUser(context, id, name))),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _showAddUserDialog(context), icon: const Icon(Icons.person_add), label: const Text('Add User')),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AddUserDialog(
        onSubmit: (name, phone, age, imagePath) async {
          final success = await context.read<UserController>().addUser(name: name, phone: phone, age: age, imagePath: imagePath);
          if (context.mounted) Helpers.showSnackBar(context, success ? 'User added successfully' : 'Failed to add user', isError: !success);
        },
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    final userCtrl = context.read<UserController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => UsersSortSheet(currentSort: userCtrl.sortType, onSortChanged: userCtrl.setSortType),
    );
  }

  void _deleteUser(BuildContext context, String id, String name) async {
    final success = await context.read<UserController>().deleteUser(id);
    if (context.mounted) Helpers.showSnackBar(context, success ? 'User deleted' : 'Failed to delete user', isError: !success);
  }

  void _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => UsersSignOutDialog(onConfirm: () {}),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AuthController>().signOut();
      if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }
}
