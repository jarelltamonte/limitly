import 'package:flutter/material.dart';
import 'package:limitly_development/intro.dart';
import 'package:limitly_development/services/auth_service.dart';
import 'package:limitly_development/screens/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:limitly_development/services/expense_service.dart';
import 'package:limitly_development/services/savings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAX37swk-j2nVenyV2x5DJA9A_ZCzF_TMU",
        authDomain: "limitly-f5acc.firebaseapp.com",
        projectId: "limitly-f5acc",
        storageBucket: "limitly-f5acc.appspot.com",
        messagingSenderId: "296728430407",
        appId: "1:296728430407:web:8dbf5a2fe108d39800ee62",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
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
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      await Future.wait([
        ExpenseService().initialize().timeout(const Duration(seconds: 10)),
        SavingsService().initialize().timeout(const Duration(seconds: 10)),
      ]);

      try {
        final snapshot = await FirebaseFirestore.instance.collection('users').get();
        for (var doc in snapshot.docs) {
          debugPrint('User doc: ${doc.id} => ${doc.data()}');
        }
      } catch (e) {
        debugPrint('Firestore test failed: $e');
      }

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _initialized = true;
      });
      // Optionally show an error message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (authService.isLoggedIn) {
      return const Dashboard();
    } else {
      return const IntroPage();
    }
  }
}