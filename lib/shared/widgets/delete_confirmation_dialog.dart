import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import 'primary_button.dart';

/// Matches the "Are you sure you want to delete..." modal from Figma.
/// TODO(later): wire this up once notification selection/deletion is enabled.
/// Not called from anywhere yet — call `showDeleteConfirmationDialog(context)`
/// when that feature is ready.
Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierColor: AppColors.modalScrim,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(false),
                child: const Icon(Icons.close, size: 20),
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error,
              ),
              child: const Icon(Icons.priority_high_rounded, color: AppColors.white),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              'Are you sure you want to delete your notifications permanently?',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.space24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.iconCircleBackground,
                      minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}