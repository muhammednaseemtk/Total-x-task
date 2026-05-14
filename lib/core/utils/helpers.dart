import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Helpers {
  Helpers._();

  static String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  static Color getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
    ];
    final index = name.isEmpty ? 0 : name.codeUnitAt(0) % colors.length;
    return colors[index];
  }

  static String formatAgeCategory(int age) {
    if (age >= 60) {
      return 'Older';
    } else {
      return 'Younger';
    }
  }

  static String formatPhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length == 10) {
      return '+91 ${digitsOnly.substring(0, 5)} ${digitsOnly.substring(5)}';
    }

    if (phone.startsWith('+91')) {
      return phone;
    }

    return phone;
  }

  static bool isValidPhone(String phone) {
    return phone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone);
  }

  static bool isValidAge(String ageStr) {
    final age = int.tryParse(ageStr);
    return age != null && age > 0 && age <= 120;
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
