import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _icons = [
    Icons.home_outlined,
    Icons.search,
    Icons.directions_car_outlined,
    Icons.notifications_none_outlined,
    Icons.person_outline,
  ];

  static const _activeIcons = [
    Icons.home,
    Icons.search,
    Icons.directions_car,
    Icons.notifications,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontalPadding,
          vertical: AppDimensions.space12,
        ),
        child: Container(
          height: AppDimensions.bottomNavHeight,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_icons.length, (index) {
              final isActive = index == currentIndex;
              return InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                onTap: () => onTap(index),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.space12),
                  child: Icon(
                    isActive ? _activeIcons[index] : _icons[index],
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}