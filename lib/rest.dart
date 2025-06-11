import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skin_disease/user_model.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
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
                        "Reset Password".tr(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff385e61),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabel("Enter your email".tr(), screenWidth),
                    _buildTextField(
                      hintText: "*****@gmail.com".tr(),
                      icon: Icons.email,
                      screenWidth: screenWidth,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 15),
                    _buildLabel("Enter new password".tr(), screenWidth),
                    _buildTextField(
                      hintText: "******",
                      icon: Icons.lock,
                      screenWidth: screenWidth,
                      isPassword: true,
                      controller: _newPasswordController,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff385e61),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.03,
                            ),
                          ),
                        ),
                        onPressed: _resetPassword,
                        child: Text(
                          "Reset Password".tr(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty || _newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields".tr())),
      );
      return;
    }
    var box = await Hive.openBox('userBox');
    var userMap = await box.get('user');

    if (userMap == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No account found with this email")),
      );
      return;
    }
    var user = User.fromMap(Map<String, dynamic>.from(userMap));
    if (_emailController.text == user.email) {
      user.password = _newPasswordController.text;
      await box.put('user', user.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset successful!".tr())),
      );
      Navigator.pushReplacementNamed(context, "Login");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email not found".tr())),
      );
    }
  }
}
