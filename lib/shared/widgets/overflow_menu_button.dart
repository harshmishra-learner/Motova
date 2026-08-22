import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';

/// A single actionable entry in the overflow menu.
class OverflowMenuItem {
  final String label;
  final VoidCallback onTap;

  const OverflowMenuItem({required this.label, required this.onTap});
}

/// The "•••" circular button seen on Notifications, Profile, and Edit Profile.
///
/// If [items] is null or empty, shows the "More features coming soon"
/// placeholder (unchanged default behavior for every screen that doesn't
/// pass anything). Screens that need real actions (e.g. Notifications'
/// "Select") pass their own [items] list.
class OverflowMenuButton extends StatelessWidget {
  final List<OverflowMenuItem>? items;

  const OverflowMenuButton({super.key, this.items});

  @override
  Widget build(BuildContext context) {
    final menuItems = items;

    return PopupMenuButton<VoidCallback>(
      icon: Container(
        width: AppDimensions.backButtonSize,
        height: AppDimensions.backButtonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      onSelected: (callback) => callback(),
      itemBuilder: (context) {
        if (menuItems == null || menuItems.isEmpty) {
          return [
            PopupMenuItem<VoidCallback>(
              enabled: false,
              child: Text('More features coming soon', style: AppTextStyles.caption),
            ),
          ];
        }

        return menuItems
            .map((item) => PopupMenuItem<VoidCallback>(
                  value: item.onTap,
                  child: Text(item.label, style: AppTextStyles.caption),
                ))
            .toList();
      },
    );
  }
}