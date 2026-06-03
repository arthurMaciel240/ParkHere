import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/app_provider.dart';
import 'services/auth_service_mock.dart';
import 'services/data_service_mock.dart';

void main() {
  // In a real Firebase app, you would initialize Firebase here:
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthServiceMock();
  final dataService = DataServiceMock();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => AppProvider(dataService)),
      ],
      child: const ParkHereApp(),
    ),
  );
}
