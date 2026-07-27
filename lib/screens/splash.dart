import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logop.png',
              width: 155,
              height: 155,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),
            Text('Pray IAFCJ', style: AppTextStyles.appTitle),
          ],
        ),
      ),
    );
  }
}
