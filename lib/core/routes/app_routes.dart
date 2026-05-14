import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'route_names.dart';
import '../../views/auth/login_screen.dart';
import '../../views/home/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
    }
  }

  static String getInitialRoute(User? user) {
    return user != null ? RouteNames.home : RouteNames.login;
  }
}