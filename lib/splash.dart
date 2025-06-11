import 'package:flutter/material.dart';
import 'package:skin_disease/signup.dart';
class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}
class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff89A8B2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:BorderRadius.circular(22) ,
              child: Image.asset(
                'assets/skin.jpg',
                width: 220,
                height: 220,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
                "Skin Disease",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff385e61),
                ),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
