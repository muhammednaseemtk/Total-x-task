import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/image_service.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService userService;
  final ImageService imageService;

  UserRepositoryImpl({
    required this.userService,
    required this.imageService,
  });

  @override
  Future<List<User>> getUsers({int page = 0, int pageSize = 20}) async {
    return await userService.getUsers(page: page, pageSize: pageSize);
  }

  @override
  Future<User?> getUserById(String id) async {
    return await userService.getUserById(id);
  }

  @override
  Future<User> addUser(User user) async {
    final model = UserModel.fromEntity(user);
    return await userService.addUser(model);
  }

  @override
  Future<User> updateUser(User user) async {
    final model = UserModel.fromEntity(user);
    return await userService.updateUser(model);
  }

  @override
  Future<void> deleteUser(String id) async {
    final user = await userService.getUserById(id);
    if (user?.imageUrl != null && user!.imageUrl!.isNotEmpty) {
      await imageService.deleteImage(user.imageUrl!);
    }
    await userService.deleteUser(id);
  }

  @override
  Future<String> uploadImage(String localPath) async {
    final String userId = DateTime.now().millisecondsSinceEpoch.toString();
    return await imageService.uploadImage(localPath, userId);
  }

  @override
  Stream<List<User>> watchUsers() {
    return userService.watchUsers();
  }
}