import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers({int page = 0, int pageSize = 20});
  Future<User?> getUserById(String id);
  Future<User> addUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);
  Future<String> uploadImage(String localPath);
  Stream<List<User>> watchUsers();
}