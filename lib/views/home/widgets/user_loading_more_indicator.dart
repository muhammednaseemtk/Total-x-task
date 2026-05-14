import 'package:flutter/material.dart';

class UserLoadingMoreIndicator extends StatelessWidget {
  const UserLoadingMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
