import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import 'user_empty_state.dart';
import 'user_error_state.dart';
import 'user_list_item.dart';
import 'user_loading_more_indicator.dart';
import 'user_no_search_results_state.dart';
import 'user_tile.dart';

class UsersListView extends StatelessWidget {
  final Function(String, String) onDeleteUser;

  const UsersListView({super.key, required this.onDeleteUser});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userCtrl, child) {
        _loadInitialUsers(context, userCtrl);

        if (userCtrl.isLoading && userCtrl.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final displayUsers = userCtrl.filteredUsers;

        if (userCtrl.errorMessage != null && displayUsers.isEmpty) {
          return UserErrorState(
            message: userCtrl.errorMessage!,
            onRetry: () {
              userCtrl.loadUsers(refresh: true);
            },
          );
        }

        if (displayUsers.isEmpty && userCtrl.searchQuery.trim().isNotEmpty) {
          return const UserNoSearchResultsState();
        }

        if (displayUsers.isEmpty) {
          return const UserEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await userCtrl.loadUsers(refresh: true);
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _loadMoreUsers(notification, userCtrl);
              return false;
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: displayUsers.length + (userCtrl.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= displayUsers.length) {
                  return const UserLoadingMoreIndicator();
                }

                final user = displayUsers[index];

                final hasImage =
                    user.imageUrl != null && user.imageUrl!.trim().isNotEmpty;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: hasImage
                      ? UserTile(
                          key: ValueKey(user.id),
                          name: user.name,
                          age: user.age,
                          imagePath: user.imageUrl!,
                          phone: user.phone,
                        )
                      : UserListItem(key: ValueKey(user.id), user: user),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _loadInitialUsers(BuildContext context, UserController userCtrl) {
    if (userCtrl.users.isEmpty &&
        !userCtrl.isLoading &&
        userCtrl.errorMessage == null &&
        userCtrl.currentPage == 0 &&
        userCtrl.hasMoreData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.read<UserController>().loadUsers(refresh: true);
        }
      });
    }
  }

  void _loadMoreUsers(
    ScrollNotification notification,
    UserController userCtrl,
  ) {
    if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200 &&
        !userCtrl.isLoading &&
        userCtrl.hasMoreData) {
      userCtrl.loadMoreUsers();
    }
  }
}
