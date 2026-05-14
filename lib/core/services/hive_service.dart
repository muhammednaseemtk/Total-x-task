import 'package:hive/hive.dart';
import '../../views/home/models/user_hive_model.dart';
import 'dart:convert';

class HiveService {
  static const String _boxPrefix = 'users';

  Box<UserHiveModel>? _box;
  String? _currentUserId;

  Future<void> init({String? userId}) async {
    if (userId != null) {
      await switchUser(userId);
    }
  }

  String _boxNameFor(String userId) {
    final encodedUserId = base64Url
        .encode(utf8.encode(userId))
        .replaceAll('=', '');
    return '${_boxPrefix}_$encodedUserId';
  }

  Future<void> switchUser(String userId) async {
    if (_currentUserId == userId && _box != null && _box!.isOpen) {
      return;
    }

    if (_box != null && _box!.isOpen) {
      await _box!.close();
    }

    _currentUserId = userId;
    _box = await Hive.openBox<UserHiveModel>(_boxNameFor(userId));
  }

  Future<void> closeCurrentUser() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
    }
    _box = null;
    _currentUserId = null;
  }

  Box<UserHiveModel> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('HiveService not initialized for the current user.');
    }
    return _box!;
  }

  Future<List<UserHiveModel>> getUsers({
    int page = 0,
    int pageSize = 20,
  }) async {
    final allUsers = box.values.toList();
    allUsers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final startIndex = page * pageSize;
    if (startIndex >= allUsers.length) return [];

    final endIndex = (startIndex + pageSize > allUsers.length)
        ? allUsers.length
        : startIndex + pageSize;

    return allUsers.sublist(startIndex, endIndex);
  }

  Future<UserHiveModel?> getUserById(String id) async {
    try {
      return box.values.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<UserHiveModel> addUser(UserHiveModel user) async {
    await box.put(user.id, user);
    return user;
  }

  Future<UserHiveModel> updateUser(UserHiveModel user) async {
    await box.put(user.id, user);
    return user;
  }

  Future<void> deleteUser(String id) async {
    await box.delete(id);
  }

  Future<int> getUserCount() async {
    return box.length;
  }

  Future<void> clearAll() async {
    await box.clear();
  }

  Future<String?> getImagePath(String userId) async {
    final user = await getUserById(userId);
    return user?.imagePath;
  }
}
