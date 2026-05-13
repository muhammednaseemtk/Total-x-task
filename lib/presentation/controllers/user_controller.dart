import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

enum SortType { all, above25, below25 }

class UserController extends ChangeNotifier {
  final UserRepository repository;

  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  String searchQuery = '';
  SortType sortType = SortType.all;
  String? errorMessage;
  int currentPage = 0;
  TextEditingController searchController = TextEditingController();

  UserController({required this.repository}) {
    searchController.addListener(onSearchChanged);
  }

  void onSearchChanged() {
    search(searchController.text);
  }

  List<User> get usersValue => filteredUsers;
  bool get isLoadingValue => isLoading;
  bool get isLoadingMoreValue => isLoadingMore;
  bool get hasMoreDataValue => hasMoreData;
  String get searchQueryValue => searchQuery;
  SortType get sortTypeValue => sortType;
  String? get errorMessageValue => errorMessage;

  Future<void> loadUsers({bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      users = [];
      hasMoreData = true;
    }

    if (!hasMoreData && !refresh) return;

    isLoading = refresh || currentPage == 0;
    errorMessage = null;
    notifyListeners();

    try {
      final newUsers = await repository.getUsers(
        page: currentPage,
        pageSize: AppConstants.pageSize,
      );

      if (refresh) {
        users = newUsers;
      } else {
        users.addAll(newUsers);
      }

      hasMoreData = newUsers.length >= AppConstants.pageSize;
      applyFilters();
    } catch (e) {
      errorMessage = 'Failed to load users';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreUsers() async {
    if (isLoadingMore || isLoading || !hasMoreData) return;

    isLoadingMore = true;
    notifyListeners();

    currentPage++;
    await loadUsers();

    isLoadingMore = false;
    notifyListeners();
  }

  Future<bool> addUser({
    required String name,
    required String phone,
    required int age,
    String? imagePath,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      String? imageUrl;
      if (imagePath != null && imagePath.isNotEmpty) {
        imageUrl = await repository.uploadImage(imagePath);
      }

      final user = User(
        id: '',
        name: name,
        phone: phone,
        age: age,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      final addedUser = await repository.addUser(user);
      users.insert(0, addedUser);
      applyFilters();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Failed to add user';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    isLoading = true;
    notifyListeners();

    try {
      await repository.updateUser(user);
      final index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = user;
        applyFilters();
      }
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Failed to update user';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      await repository.deleteUser(id);
      users.removeWhere((u) => u.id == id);
      applyFilters();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Failed to delete user';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void search(String query) {
    searchQuery = query.trim().toLowerCase();
    applyFilters();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery = '';
    applyFilters();
  }

  void setSortType(SortType type) {
    sortType = type;
    applyFilters();
  }

  void applyFilters() {
    filteredUsers = users.where((user) {
      final matchesSearch = searchQuery.isEmpty ||
          user.name.toLowerCase().contains(searchQuery) ||
          user.phone.contains(searchQuery);

      final matchesSort = sortType == SortType.all ||
          (sortType == SortType.above25 && user.ageAbove25) ||
          (sortType == SortType.below25 && user.ageBelow25);

      return matchesSearch && matchesSort;
    }).toList();

    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void reset() {
    users = [];
    filteredUsers = [];
    searchQuery = '';
    sortType = SortType.all;
    currentPage = 0;
    hasMoreData = true;
    searchController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
