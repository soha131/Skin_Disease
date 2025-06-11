import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'cubit/skin_cubit.dart';
import 'login.dart';
import 'rest.dart';
import 'signup.dart';
import 'splash.dart';
import 'upload_image.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: BlocProvider(
        create: (context) => SkinPredictionCubit(),
        child:  MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      localeResolutionCallback: (locale, supportedLocales) {
        return supportedLocales.contains(locale) ? locale : supportedLocales.first;
      },
      home: const Splash(),
      routes: {
        "upload": (context) => const UploadFileScreen(),
        "Signup": (context) => const SignUpScreen(),
        "Login": (context) => const LoginScreen(),
        "Rest": (context) => const ResetPasswordScreen(),
      },
    );
  }
}
