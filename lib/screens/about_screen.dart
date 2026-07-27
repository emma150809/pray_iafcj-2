import 'package:flutter/material.dart';
import 'package:pray_iafcj/core/app_colors.dart';
import 'package:pray_iafcj/core/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text(
          'Sobre la aplicación',
          style: AppTextStyles.screenTitle.copyWith(height: 0.95),
          textAlign: TextAlign.center,
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/logop.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Desarrollada con fines espirituales para mayor constancia en los reportes de oración y lectura, fomentando los buenos hábitos espirituales en los jóvenes y personas que usan la aplicación.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.secondaryText,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Text(
                'Desarrollada por: Emma Orix',
                style: AppTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Versión: 1.0.0',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '© 2026 Pray',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                'Dudas o sugerencias, comuníquese personalmente con la administradora al +61 4733 3342.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.secondaryText,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
