import 'package:flutter/material.dart';
import 'package:pray_iafcj/screens/auth/login_screen.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logop.png',
                  width: 175,
                  height: 175,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 18),
                Text('Pray IAFCJ', style: AppTextStyles.appTitle),
                const SizedBox(height: 35),
                Text(
                  'Registro de oraci\u00f3n y\nlectura b\u00edblica personal',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 45),
                AppButton(
                  text: 'Continuar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
