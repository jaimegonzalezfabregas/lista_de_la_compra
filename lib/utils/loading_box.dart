import 'package:flutter/material.dart';

class LoadingBox extends StatelessWidget {
  const LoadingBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
