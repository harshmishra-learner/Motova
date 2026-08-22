import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/overflow_menu_button.dart';
import '../../../shared/widgets/profile_menu_row.dart';

// TODO(Day 16): replace mock user data with real AuthRepository data.
class _MockUser {
  static const fullName = 'Harsh Mishra';
  static const email = 'mishra30harsh@gmail.com';
  static const avatarUrl = 'assets/images/about.jpg';
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppDimensions.space16),
            child: OverflowMenuButton(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppDimensions.space32),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontalPadding,
              vertical: AppDimensions.space16,
            ),
            child: Row(
              children: [
                _ProfileAvatar(size: AppDimensions.avatarSizeMedium),
                const SizedBox(width: AppDimensions.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _MockUser.fullName,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(_MockUser.email, style: AppTextStyles.footerText),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => context.push(AppRoutes.editProfile),
                  child: Column(
                    children: [
                      const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                      const SizedBox(height: 2),
                      Text('Edit profile', style: AppTextStyles.footerText),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          const _SectionLabel('General'),
          ProfileMenuRow(
            icon: Icons.favorite_border,
            label: 'Favorite Cars',
            onTap: () {},
          ),
          ProfileMenuRow(
            icon: Icons.history,
            label: 'Previous Rent',
            onTap: () {},
          ),
          ProfileMenuRow(
            icon: Icons.notifications_none_outlined,
            label: 'Notification',
            onTap: () => context.push(AppRoutes.notifications),
          ),
          ProfileMenuRow(
            icon: Icons.hub_outlined,
            label: 'Connected to QENT Partnerships',
            onTap: () {},
          ),

          const SizedBox(height: AppDimensions.space16),

          const _SectionLabel('Support'),
          ProfileMenuRow(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {},
          ),
          ProfileMenuRow(
            icon: Icons.language_outlined,
            label: 'Languages',
            onTap: () {},
          ),
          ProfileMenuRow(
            icon: Icons.person_add_alt_outlined,
            label: 'Invite Friends',
            onTap: () {},
          ),
          ProfileMenuRow(
            icon: Icons.privacy_tip_outlined,
            label: 'privacy policy',
            onTap: () {},
          ),
          ProfileMenuRow(
            icon: Icons.headset_mic_outlined,
            label: 'Help Support',
            onTap: () {},
          ),
          ProfileMenuRow(
            icon: Icons.logout,
            label: 'Log out',
            onTap: () {
              // TODO(Day 19): clear token via SecureStorage, then
              // context.go(AppRoutes.login).
            },
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        AppDimensions.space16,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.space8,
      ),
      child: Text(
        text,
        style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final double size;
  final bool showEditBadge;
  final VoidCallback? onEditTap;

  const _ProfileAvatar({
    required this.size,
    this.showEditBadge = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.iconCircleBackground,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            _MockUser.avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.person,
              size: size * 0.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        if (showEditBadge)
          Positioned(
            bottom: -2,
            right: -2,
            child: InkWell(
              onTap: onEditTap,
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: const Icon(Icons.camera_alt_outlined, size: 14, color: AppColors.textPrimary),
              ),
            ),
          ),
      ],
    );
  }
}