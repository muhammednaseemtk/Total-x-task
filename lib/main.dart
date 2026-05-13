import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/firebase_auth_service.dart';
import 'data/services/image_service.dart';
import 'data/services/user_service.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/user_controller.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authService = FirebaseAuthService();
  final userService = UserService();
  final imageService = ImageService();

  final userRepository = UserRepositoryImpl(
    userService: userService,
    imageService: imageService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(authService: authService),
        ),
        ChangeNotifierProvider(
          create: (_) => UserController(repository: userRepository),
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
