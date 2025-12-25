import 'package:flutter/material.dart';

class TestImageScreen extends StatelessWidget {
  const TestImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const url = "https://ibb.co/ycxQVyVP";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Image'),
      ),
      body: Center(
        child: Image.network(url, height: 200, width: 200, fit: BoxFit.cover,
            errorBuilder: (context, error, StackTrace) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                Icons.broken_image,
                size: 40,
                color: Colors.red,
              ),
              Text('$error'),
            ],
          );
        }),
      ),
    );
  }
}
