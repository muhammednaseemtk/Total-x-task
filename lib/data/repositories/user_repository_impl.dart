import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../models/user_hive_model.dart';
import '../services/user_service.dart';
import '../services/user_hive_service.dart';
import '../services/local_image_service.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService userService;
  final UserHiveService userHiveService;
  final LocalImageService localImageService;

  UserRepositoryImpl({
    required this.userService,
    required this.userHiveService,
    required this.localImageService,
  });

  @override
  Future<List<User>> getUsers({int page = 0, int pageSize = 20}) async {
    // Get user details from Firestore
    final firestoreUsers = await userService.getUsers(page: page, pageSize: pageSize);
    
    // Get image paths from Hive
    final imagePaths = await _getAllImagePaths();
    
    // Combine user details with image paths
    return firestoreUsers.map((user) {
      final imagePath = imagePaths[user.id];
      return User(
        id: user.id,
        name: user.name,
        phone: user.phone,
        age: user.age,
        imageUrl: imagePath,
        createdAt: user.createdAt,
      );
    }).toList();
  }

  @override
  Future<User?> getUserById(String id) async {
    final user = await userService.getUserById(id);
    if (user == null) return null;
    
    final imagePath = await userHiveService.getImagePath(id);
    return User(
      id: user.id,
      name: user.name,
      phone: user.phone,
      age: user.age,
      imageUrl: imagePath,
      createdAt: user.createdAt,
    );
  }

  @override
  Future<User> addUser(User user) async {
    // Save user details to Firestore
    final userModel = UserModel.fromEntity(user);
    final addedUser = await userService.addUser(userModel);
    
    // Save image path to Hive if exists
    if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
      final hiveUser = UserHiveModel(
        id: addedUser.id,
        name: '',
        phone: '',
        age: 0,
        imagePath: user.imageUrl,
        createdAt: DateTime.now(),
      );
      await userHiveService.addUser(hiveUser);
    }
    
    return User(
      id: addedUser.id,
      name: addedUser.name,
      phone: addedUser.phone,
      age: addedUser.age,
      imageUrl: user.imageUrl,
      createdAt: addedUser.createdAt,
    );
  }

  @override
  Future<User> updateUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    final updatedUser = await userService.updateUser(userModel);
    
    // Update image path in Hive if exists
    if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
      final existingHiveUser = await userHiveService.getUserById(user.id);
      if (existingHiveUser != null) {
        existingHiveUser.imagePath = user.imageUrl;
        await userHiveService.updateUser(existingHiveUser);
      } else {
        final hiveUser = UserHiveModel(
          id: user.id,
          name: '',
          phone: '',
          age: 0,
          imagePath: user.imageUrl,
          createdAt: DateTime.now(),
        );
        await userHiveService.addUser(hiveUser);
      }
    }
    
    return User(
      id: updatedUser.id,
      name: updatedUser.name,
      phone: updatedUser.phone,
      age: updatedUser.age,
      imageUrl: user.imageUrl,
      createdAt: updatedUser.createdAt,
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    // Get user to check for image
    final user = await userService.getUserById(id);
    
    // Delete user from Firestore
    await userService.deleteUser(id);
    
    // Delete image path from Hive
    await userHiveService.deleteUser(id);
    
    // Delete local image file if exists
    if (user?.imageUrl != null && user!.imageUrl!.isNotEmpty) {
      await localImageService.deleteImage(user.imageUrl!);
    }
  }

  @override
  Future<String> uploadImage(String localPath) async {
    // Save image to local directory
    return await localImageService.saveImage(localPath);
  }

  @override
  Stream<List<User>> watchUsers() {
    return userService.watchUsers();
  }

  Future<Map<String, String>> _getAllImagePaths() async {
    final allUsers = await userHiveService.getUsers(page: 0, pageSize: 1000);
    final Map<String, String> paths = {};
    for (final user in allUsers) {
      if (user.imagePath != null && user.imagePath!.isNotEmpty) {
        paths[user.id] = user.imagePath!;
      }
    }
    return paths;
  }
}