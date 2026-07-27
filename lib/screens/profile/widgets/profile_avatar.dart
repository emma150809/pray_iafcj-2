import 'package:flutter/material.dart';

import 'package:pray_iafcj/core/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.imageUrl, this.onEdit});

  final String? imageUrl;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// Borde exterior
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 4),
          ),
        ),

        /// Avatar
        CircleAvatar(
          radius: 52,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
              ? NetworkImage(imageUrl!)
              : null,
          child: imageUrl == null || imageUrl!.isEmpty
              ? const Icon(Icons.person, size: 70, color: Colors.black54)
              : null,
        ),

        /// Botón editar
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary),
              ),
              child: const Icon(Icons.edit, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
