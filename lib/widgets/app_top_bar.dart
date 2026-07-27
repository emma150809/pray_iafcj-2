import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onInfoPressed;

  const AppTopBar({super.key, required this.title, this.onInfoPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      centerTitle: true,
      leadingWidth: 66,
      leading: Padding(
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          'assets/images/logop.png',
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.screenTitle.copyWith(height: 0.95),
        textAlign: TextAlign.center,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          color: AppColors.primary,
          onPressed: onInfoPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66);
}
