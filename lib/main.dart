import 'package:flutter/material.dart';
import 'package:limitly_development/intro.dart';
import 'package:limitly_development/services/auth_service.dart';
import 'package:limitly_development/screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Limitly Development',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 13, 100, 70)),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    // Check if user is logged in
    if (authService.isLoggedIn) {
      return const Dashboard();
    } else {
      return const IntroPage();
    }
  }
}
