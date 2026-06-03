import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/driver/driver_home_screen.dart';
import 'screens/owner/owner_home_screen.dart';

class ParkHereApp extends StatelessWidget {
  const ParkHereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkHere',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        // Show splash while checking auth state (simulated)
        if (auth.loading) {
          return const SplashScreen();
        }

        if (!auth.isAuthenticated) {
          return const LoginScreen();
        }

        if (auth.isDriver) {
          return const DriverHomeScreen();
        }

        if (auth.isOwner) {
          return const OwnerHomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
