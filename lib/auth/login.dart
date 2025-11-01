import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../core/models/user_model.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return  Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
               color: Color(0xff385e61)
              ),
            ),

            Positioned(
              top: screenHeight * 0.3,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                height: screenHeight * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(screenWidth * 0.15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                      child: Text(
                        "Login".tr(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff385e61),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabel("EMAIL".tr(), screenWidth),
                    _buildTextField(
                      hintText: "*****@gmail.com".tr(),
                      icon: Icons.email,
                      screenWidth: screenWidth,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 15),
                    _buildLabel("PASSWORD".tr(), screenWidth),
                    _buildTextField(
                      hintText: "******",
                      icon: Icons.lock,
                      screenWidth: screenWidth,
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff385e61),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                        ),
                        onPressed: _login,
                        child: Text(
                          "Log in".tr(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "Rest");
                      },
                      child: Text(
                        "Forgot Password?".tr(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "Signup");
                      },
                      child: Text(
                        "Sign Up!".tr(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Locale newLocale = context.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
            context.setLocale(newLocale);

          },
          backgroundColor: Colors.white,
          child: Icon(Icons.language, color: Color(0xff385e61)),
        ),
    );
  }
  Widget _buildLabel(String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.03, bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required double screenWidth,
    bool isPassword = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.grey,
        obscureText: isPassword && !_isPasswordVisible,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    var box = await Hive.openBox('userBox');
    var userMap = await box.get('user');

    if (userMap == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No account found, please sign up first")),
      );
      return;
    }

    var user = User.fromMap(Map<String, dynamic>.from(userMap));

    if (_emailController.text == user.email && _passwordController.text == user.password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login successful!")),
      );
      Navigator.pushReplacementNamed(context, "upload");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

}
