import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/image_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/custom_widgets.dart';
import 'login_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final searchCtrl = TextEditingController();
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<UserController>().loadUsers());
    scrollCtrl.addListener(() {
      if (scrollCtrl.position.pixels >= scrollCtrl.position.maxScrollExtent - 200) {
        context.read<UserController>().loadMoreUsers();
      }
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }

  void showAddUserDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _AddUserDialogContent(
        onSubmit: (name, phone, age, imagePath) async {
          final success = await context.read<UserController>().addUser(name: name, phone: phone, age: age, imagePath: imagePath);
          if (mounted) Helpers.showSnackBar(context, success ? 'User added successfully' : 'Failed to add user', isError: !success);
        },
      ),
    );
  }

  void showSortSheet() {
    final userCtrl = context.read<UserController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHandle(),
            const SizedBox(height: 20),
            const Text('Sort By Age', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            ...SortType.values.map((type) => Column(children: [
                  SortOptionItem(
                    title: type == SortType.all ? 'All Users' : type == SortType.above60 ? 'Age: Above 60 (Older)' : 'Age: Below 60 (Younger)',
                    isSelected: userCtrl.sortType == type,
                    onTap: () {
                      userCtrl.setSortType(type);
                      Navigator.pop(ctx);
                    },
                  ),
                  if (type != SortType.below60) const Divider(height: 1),
                ])),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void confirmDelete(String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await context.read<UserController>().deleteUser(id);
              if (mounted) Helpers.showSnackBar(context, success ? 'User deleted' : 'Failed to delete user', isError: !success);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sign Out')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<AuthController>().signOut();
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          LocationHeader(location: 'Nilambur', onLogout: signOut),
          Consumer<UserController>(
            builder: (context, userCtrl, child) => SearchFilterBar(
              controller: searchCtrl,
              onSearch: userCtrl.search,
              onClear: () => userCtrl.search(''),
              onFilter: showSortSheet,
            ),
          ),
          Expanded(
            child: Consumer<UserController>(
              builder: (context, userCtrl, child) {
                if (userCtrl.isLoading && userCtrl.users.isEmpty) return const Center(child: CircularProgressIndicator());
                if (userCtrl.errorMessage != null && userCtrl.users.isEmpty) return ErrorStateView(message: userCtrl.errorMessage!, onRetry: () => userCtrl.loadUsers(refresh: true));
                if (userCtrl.users.isEmpty) return const EmptyStateView(title: 'No users found', subtitle: 'Add your first user by tapping the button below');

                return RefreshIndicator(
                  onRefresh: () => userCtrl.loadUsers(refresh: true),
                  child: ListView.builder(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.all(16),
                    itemCount: userCtrl.users.length + (userCtrl.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == userCtrl.users.length) return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                      final user = userCtrl.users[index];
                      return UserListItem(user: user, onDelete: () => confirmDelete(user.id, user.name));
                    },
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: showAddUserDialog, icon: const Icon(Icons.person_add), label: const Text('Add User')),
    );
  }
}

class _AddUserDialogContent extends StatefulWidget {
  final Function(String, String, int, String?) onSubmit;

  const _AddUserDialogContent({required this.onSubmit});

  @override
  State<_AddUserDialogContent> createState() => _AddUserDialogContentState();
}

class _AddUserDialogContentState extends State<_AddUserDialogContent> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  String? imagePath;

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }

  void submit() {
    if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty && ageCtrl.text.isNotEmpty) {
      widget.onSubmit(nameCtrl.text.trim(), phoneCtrl.text.trim(), int.parse(ageCtrl.text.trim()), imagePath);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add New User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.white,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (ctx) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ListTile(
                        leading: const Icon(Icons.photo_library, color: AppColors.primary),
                        title: const Text('Choose from Gallery'),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final ctrl = ImageControllerUtil();
                          await ctrl.pickImageFromGallery();
                          if (ctrl.imagePath != null) setState(() => imagePath = ctrl.imagePath);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                        title: const Text('Take a Photo'),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final ctrl = ImageControllerUtil();
                          await ctrl.pickImageFromCamera();
                          if (ctrl.imagePath != null) setState(() => imagePath = ctrl.imagePath);
                        },
                      ),
                    ]),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.lightGrey, border: Border.all(color: AppColors.divider, width: 2)),
                  child: imagePath != null
                      ? ClipOval(child: Image.file(File(imagePath!), fit: BoxFit.cover, width: 100, height: 100))
                      : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.camera_alt, color: AppColors.grey, size: 32),
                          const SizedBox(height: 4),
                          Text('Add Photo', style: TextStyle(fontSize: 12, color: AppColors.grey.withAlpha(179))),
                        ]),
                ),
              ),
              const SizedBox(height: 20),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline))),
              const SizedBox(height: 16),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)), keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: 'Age', prefixIcon: Icon(Icons.cake_outlined)), keyboardType: TextInputType.number),
              const SizedBox(height: 24),
              Row(children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const SizedBox(width: 16),
                Expanded(child: ElevatedButton(onPressed: submit, child: const Text('Save'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}