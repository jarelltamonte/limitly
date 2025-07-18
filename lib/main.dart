import 'package:flutter/material.dart';
import 'package:limitly_development/login_page.dart';
import 'package:limitly_development/intro.dart';

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
      home: const IntroPage(),
    );
  }
}
