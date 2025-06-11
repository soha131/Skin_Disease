import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skin_disease/user_model.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
              decoration: const BoxDecoration(
                color: Color(0xff385e61)
              ),
            ),
            Positioned(
              top: screenHeight * 0.19,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                height: screenHeight * 0.90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),

                    Text(
                     "Create new\nAccount".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff385e61),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already Registered?".tr(),
                          style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "Login");
                          },
                          child: Text(
                          "Log in here.".tr(),
                            style: TextStyle(
                              color: Color(0xff385e61),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildLabel("NAME".tr(), screenWidth),
                    _buildTextField(
                      controller: nameController,
                      hintText: "Your Name".tr(),
                      icon: Icons.person,
                      screenWidth: screenWidth,
                    ),
                    const SizedBox(height: 15),
                    _buildLabel("EMAIL".tr(), screenWidth),
                    _buildTextField(
                      controller: emailController,
                      hintText:"*****@gmail.com".tr(),
                      icon: Icons.email,
                      screenWidth: screenWidth,
                    ),
                    const SizedBox(height: 15),
                    _buildLabel("PASSWORD".tr(), screenWidth),
                    _buildTextField(
                      controller: passwordController,
                      hintText: "******",
                      icon: Icons.lock,
                      screenWidth: screenWidth,
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),
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
                        onPressed: () async {
                          if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please fill all fields".tr())),
                            );
                            return;
                          }

                          var box = await Hive.openBox('userBox');
                          var user = User(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          // Save user data to Hive
                          box.put('user', user.toMap());

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Account created successfully".tr())),
                          );

                          // Optionally, navigate to the login screen
                          Navigator.pushNamed(context, "Login");
                        },
                        child: Text(
                          "Sign Up".tr(),
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
      padding: EdgeInsets.only(left: screenWidth * 0.02, bottom: 5),
      child: Align(
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
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.grey,
        obscureText: isPassword && !_isPasswordVisible,
        textAlign:  TextAlign.left,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon:
          isPassword
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
}
