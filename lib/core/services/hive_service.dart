import 'package:hive/hive.dart';
import '../../views/home/models/user_hive_model.dart';

class HiveService {
  static const String _boxName = 'users';
  
  Box<UserHiveModel>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<UserHiveModel>(_boxName);
  }

  Box<UserHiveModel> get box {
    if (_box == null) {
      throw Exception('HiveService not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<List<UserHiveModel>> getUsers({int page = 0, int pageSize = 20}) async {
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