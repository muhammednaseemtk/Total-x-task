import 'package:flutter/material.dart';

class AddUserTitleWidget extends StatelessWidget {
  const AddUserTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Add A New User',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}
