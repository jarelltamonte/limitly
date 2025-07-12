import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:limitly_development/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkGreen = const Color(0xFF006231);
    final lightGreen = const Color(0xFFEAF8EF);
    final fieldGreen = const Color(0xFFDEF8E1); 

    return Scaffold(
      backgroundColor: darkGreen,
      body: Column(
        children: [
          // Top green banner with "Welcome"
          Container(
            height: 180,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 24),
            child: const Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          // Login form with rounded top
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Username Or Email',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'example@example.com',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                        filled: true,
                        fillColor: fieldGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                        filled: true,
                        fillColor: fieldGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Implement login logic
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xFF005F3C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupPage()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(''),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Or Log In with',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google logo
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Image.network(
                                    'https://en.m.wikipedia.org/wiki/File:Google_%22G%22_logo.svg#/media/File%3AGoogle_Favicon_2025.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Apple logo
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1024px-Apple_logo_black.svg.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}