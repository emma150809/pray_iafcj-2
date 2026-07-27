import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:pray_iafcj/firebase_options.dart';
import 'package:pray_iafcj/core/app_theme.dart';
import 'package:pray_iafcj/screens/about_screen.dart';
import 'package:pray_iafcj/screens/profile/profile_screen.dart';
import 'package:pray_iafcj/screens/welcome/welcome_screen.dart';
import 'package:pray_iafcj/screens/auth/login_screen.dart';
import 'package:pray_iafcj/screens/auth/register_screen.dart';
import 'package:pray_iafcj/screens/home/home.dart';
import 'package:pray_iafcj/screens/lectura.dart';
import 'package:pray_iafcj/screens/oracion.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PrayIAFCJ());
}

class PrayIAFCJ extends StatelessWidget {
  const PrayIAFCJ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pray IAFCJ',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/lectura': (context) => const LecturaScreen(),
        '/oracion': (context) => const OracionScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
