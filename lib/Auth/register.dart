// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ai_masa/Auth/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPassVisible = false;
  bool _isConfirmPassVisible = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Sweet Background Glows (Mint Green theme for Freshness)
            Positioned(
              top: -50,
              right: -50,
              child: _buildBlurCircle(250, Colors.green.shade100),
            ),
            Positioned(
              bottom: -100,
              left: -50,
              child: _buildBlurCircle(300, Colors.green.shade50),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // App Name & Welcome Note
                      Text(
                        "Al-Masa 🍰",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Register now to order the most delicious cakes and cookies in town!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Full Name
                      _buildLabel("Your Name"),
                      _buildTextField(
                        controller: _nameController,
                        hint: "Enter your full name",
                        icon: Icons.person_outline_rounded,
                        validator: (v) =>
                            v!.isEmpty ? "We'd love to know your name!" : null,
                      ),

                      const SizedBox(height: 15),

                      // Phone Number with Country Flag
                      _buildLabel("Phone Number (For Delivery Updates)"),
                      IntlPhoneField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          filled: true,
                          fillColor: Colors.green.shade50.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.green.shade700,
                              width: 2,
                            ),
                          ),
                        ),
                        initialCountryCode: 'IN',
                      ),

                      const SizedBox(height: 10),

                      // Email
                      _buildLabel("Email Address"),
                      _buildTextField(
                        controller: _emailController,
                        hint: "example@mail.com",
                        icon: Icons.email_outlined,
                        validator: (v) => !v!.contains('@')
                            ? "Please enter a valid email"
                            : null,
                      ),

                      const SizedBox(height: 15),

                      // Password
                      _buildLabel("Password"),
                      _buildTextField(
                        controller: _passController,
                        hint: "••••••••",
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isPasswordVisible: _isPassVisible,
                        toggleVisibility: () =>
                            setState(() => _isPassVisible = !_isPassVisible),
                        validator: (v) => v!.length < 6
                            ? "Password must be 6+ characters"
                            : null,
                      ),

                      const SizedBox(height: 15),

                      // Confirm Password
                      _buildLabel("Confirm Password"),
                      _buildTextField(
                        controller: _confirmPassController,
                        hint: "••••••••",
                        icon:
                            Icons.cake_outlined, // Sweet icon for confirmation
                        isPassword: true,
                        isPasswordVisible: _isConfirmPassVisible,
                        toggleVisibility: () => setState(
                          () => _isConfirmPassVisible = !_isConfirmPassVisible,
                        ),
                        validator: (v) {
                          if (v != _passController.text) {
                            return "Passwords don't match!";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 35),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: Colors.green.withOpacity(0.4),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Show a sweet success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Welcome to Al-Masa! Get ready for some treats! 🍪',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "START TREATS",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already a foodie? "),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              ),
                              child: Text(
                                "Login Here",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---
  Widget _buildBlurCircle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 5),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: toggleVisibility,
              )
            : null,
        hintText: hint,
        filled: true,
        fillColor: Colors.green.shade50.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
        ),
      ),
    );
  }
}
