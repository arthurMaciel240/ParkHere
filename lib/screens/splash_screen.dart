import 'package:flutter/material.dart';

import '../core/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_parking, size: 100, color: Colors.white),
            SizedBox(height: 24),
            Text(
              'ParkHere',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
