import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'views/home/models/user_hive_model.dart';
import 'core/services/hive_service.dart';
import 'core/services/image_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/user_repository.dart';
import 'views/auth/controllers/auth_controller.dart';
import 'views/home/controllers/user_controller.dart';
import 'views/home/controllers/image_controller.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveModelAdapter());
  
  final hiveService = HiveService();
  await hiveService.init();
  
  final imageService = ImageService();
  final authRepository = AuthRepository();
  final userRepository = UserRepository(
    hiveService: hiveService,
    imageService: imageService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(authRepository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => UserController(repository: userRepository),
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
      initialRoute: RouteNames.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}