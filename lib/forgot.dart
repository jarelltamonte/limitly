// forgot.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    // Basic validation
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.resetPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password has been reset successfully!'),
          ),
        );
        // Navigate back to the login page after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset failed. Please try again.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          // Top Banner
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Positioned(
                  left: 4,
                  bottom: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),

          // Form
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
                    buildLabel('Email'),
                    buildTextField(
                      controller: _emailController,
                      hintText: 'example@example.com',
                      keyboardType: TextInputType.emailAddress,
                      fieldGreen: fieldGreen,
                    ),
                    buildLabel('New Password'),
                    buildPasswordField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      toggle: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      fieldGreen: fieldGreen,
                    ),
                    buildLabel('Confirm New Password'),
                    buildPasswordField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      toggle: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                      fieldGreen: fieldGreen,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _isLoading ? null : _resetPassword,
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
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

  Widget buildLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
    child: Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: 'Poppins',
      ),
    ),
  );

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Color fieldGreen,
    TextInputType? keyboardType,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      filled: true,
      fillColor: fieldGreen,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggle,
    required Color fieldGreen,
  }) => TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: '••••••••',
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      filled: true,
      fillColor: fieldGreen,
      suffixIcon: IconButton(
        icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: toggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
