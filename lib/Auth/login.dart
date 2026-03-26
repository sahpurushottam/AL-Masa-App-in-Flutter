// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:ai_masa/Auth/ForgotPasswordScreen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ai_masa/Services/auth_services.dart';
import 'package:ai_masa/global/Global.dart';
import 'package:ai_masa/myScreen/Mainpage.dart';
import 'package:ai_masa/Auth/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailandPhone = TextEditingController();
  final _password = TextEditingController();
  bool _isObscure = true;
  final storage = const FlutterSecureStorage();

  String? show_error;
  bool _isButtonDisabled = false;

  // --- API LOGIC (As per your code) ---
  Future<void> _onLoginSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isButtonDisabled = true;
        show_error = null;
      });

      var data_array = {
        "username": _emailandPhone.text.trim(),
        "password": _password.text.trim(),
      };

      await AuthServices.login(data_array)
          .then((response_data) async {
            if (response_data != null) {
              if (response_data['status'] == true) {
                await storage.write(
                  key: 'distributor_access_token',
                  value: response_data['token'],
                );
                setState(() {
                  app_auth_token = response_data['token'];
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (c) => const MainPage()),
                );
              } else {
                setState(() {
                  show_error = response_data['error_message'];
                });
              }
            }
          })
          .catchError((errorMessage) {
            setState(() {
              show_error = "Something went wrong. Please try again.";
            });
          })
          .whenComplete(() {
            setState(() {
              _isButtonDisabled = false;
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // --- DHAMAKEDAR BACKGROUND DESIGN ---
            Positioned(
              top: -100,
              right: -50,
              child: _buildBlurCircle(
                300,
                Colors.green.shade100.withOpacity(0.7),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: _buildBlurCircle(250, Colors.green.shade50),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),

                      // Title Section
                      FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Al-Masa 🍪',
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Welcome back! Login to grab your favorite treats.',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Input Fields
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildInputField(
                                controller: _emailandPhone,
                                hint: "Email or Phone Number",
                                icon: Icons.person_outline_rounded,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter User Id';
                                  }
                                  return null;
                                },
                              ),
                              Divider(
                                color: Colors.grey.shade100,
                                thickness: 2,
                              ),
                              _buildInputField(
                                controller: _password,
                                hint: "Password",
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Error Message
                      if (show_error != null)
                        FadeIn(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 10),
                            child: Text(
                              show_error!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Forgot Password
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const ForgotPasswordScreen(),
                                ),
                              );
                            }, // Forgot Password Screen Link
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Login Button
                      FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              elevation: 10,
                              shadowColor: Colors.green.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: _isButtonDisabled
                                ? null
                                : _onLoginSubmit,
                            child: _isButtonDisabled
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Bottom Register Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const RegisterPage(),
                                ),
                              ),
                              child: Text(
                                "Sign Up Now",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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

  // --- UI HELPERS ---

  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _isObscure : false,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              )
            : null,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }
}
