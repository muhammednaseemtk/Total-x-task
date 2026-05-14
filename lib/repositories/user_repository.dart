import '../views/home/models/user_model.dart';
import '../core/services/user_service.dart';
import '../core/services/hive_service.dart';
import '../core/services/image_service.dart';
import '../views/home/models/user_hive_model.dart';

class UserRepository {
  final UserService _userService;
  final HiveService _hiveService;
  final ImageService _imageService;

  UserRepository({
    UserService? userService,
    HiveService? hiveService,
    ImageService? imageService,
  })  : _userService = userService ?? UserService(),
        _hiveService = hiveService ?? HiveService(),
        _imageService = imageService ?? ImageService();

  Future<List<UserModel>> getUsers({int page = 0, int pageSize = 20}) async {
    final firestoreUsers = await _userService.getUsers(page: page, pageSize: pageSize);
    
    final imagePaths = await _getAllImagePaths();
    
    return firestoreUsers.map((user) {
      final imagePath = imagePaths[user.id];
      return UserModel(
        id: user.id,
        name: user.name,
        phone: user.phone,
        age: user.age,
        imageUrl: imagePath,
        createdAt: user.createdAt,
      );
    }).toList();
  }

  Future<UserModel?> getUserById(String id) async {
    final user = await _userService.getUserById(id);
    if (user == null) return null;
    
    final imagePath = await _hiveService.getImagePath(id);
    return UserModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      age: user.age,
      imageUrl: imagePath,
      createdAt: user.createdAt,
    );
  }

  Future<UserModel> addUser(UserModel user) async {
    final addedUser = await _userService.addUser(user);
    
    if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
      final hiveUser = UserHiveModel(
        id: addedUser.id,
        name: '',
        phone: '',
        age: 0,
        imagePath: user.imageUrl,
        createdAt: DateTime.now(),
      );
      await _hiveService.addUser(hiveUser);
    }
    
    return UserModel(
      id: addedUser.id,
      name: addedUser.name,
      phone: addedUser.phone,
      age: addedUser.age,
      imageUrl: user.imageUrl,
      createdAt: addedUser.createdAt,
    );
  }

  Future<UserModel> updateUser(UserModel user) async {
    final updatedUser = await _userService.updateUser(user);
    
    if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
      final existingHiveUser = await _hiveService.getUserById(user.id);
      if (existingHiveUser != null) {
        existingHiveUser.imagePath = user.imageUrl;
        await _hiveService.updateUser(existingHiveUser);
      } else {
        final hiveUser = UserHiveModel(
          id: user.id,
          name: '',
          phone: '',
          age: 0,
          imagePath: user.imageUrl,
          createdAt: DateTime.now(),
        );
        await _hiveService.addUser(hiveUser);
      }
    }
    
    return UserModel(
      id: updatedUser.id,
      name: updatedUser.name,
      phone: updatedUser.phone,
      age: updatedUser.age,
      imageUrl: user.imageUrl,
      createdAt: updatedUser.createdAt,
    );
  }

  Future<void> deleteUser(String id) async {
    final user = await _userService.getUserById(id);
    
    await _userService.deleteUser(id);
    await _hiveService.deleteUser(id);
    
    if (user?.imageUrl != null && user!.imageUrl!.isNotEmpty) {
      await _imageService.deleteImage(user.imageUrl!);
    }
  }

  Future<String> uploadImage(String localPath) async {
    return await _imageService.saveImage(localPath);
  }

  Stream<List<UserModel>> watchUsers() {
    return _userService.watchUsers();
  }

  Future<Map<String, String>> _getAllImagePaths() async {
    final allUsers = await _hiveService.getUsers(page: 0, pageSize: 1000);
    final Map<String, String> paths = {};
    for (final user in allUsers) {
      if (user.imagePath != null && user.imagePath!.isNotEmpty) {
        paths[user.id] = user.imagePath!;
      }
    }
    return paths;
  }
}