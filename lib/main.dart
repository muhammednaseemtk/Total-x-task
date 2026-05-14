import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'data/models/user_hive_model.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/user_service.dart';
import 'data/services/user_hive_service.dart';
import 'data/services/local_image_service.dart';
import 'data/services/firebase_auth_service.dart';
import 'presentation/controllers/user_controller.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/image_controller.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase for user data (Firestore)
  await Firebase.initializeApp();
  
  // Initialize Hive for image paths
  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveModelAdapter());
  
  // Initialize services
  final userService = UserService();
  final userHiveService = UserHiveService();
  await userHiveService.init();
  final localImageService = LocalImageService();
  final firebaseAuthService = FirebaseAuthService();
  
  // Create repository
  final userRepository = UserRepositoryImpl(
    userService: userService,
    userHiveService: userHiveService,
    localImageService: localImageService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserController(repository: userRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthController(authService: firebaseAuthService),
        ),
        ChangeNotifierProvider(
          create: (_) => ImageController(),
        ),
      ],
      child: const TotalXApp(),
    ),
  );
}

class TotalXApp extends StatelessWidget {
  const TotalXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOTAL-X',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}