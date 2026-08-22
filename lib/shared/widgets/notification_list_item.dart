import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import '../../features/notifications/models/notification_item.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationItem item;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onTap;

  const NotificationListItem({
    super.key,
    required this.item,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? AppColors.iconCircleBackground : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontalPadding,
          vertical: AppDimensions.space16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSelectionMode) ...[
              _SelectionCheckCircle(isSelected: isSelected),
              const SizedBox(width: AppDimensions.space12),
            ],
            Container(
              width: AppDimensions.iconCircleSize,
              height: AppDimensions.iconCircleSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.iconCircleBackground,
              ),
              child: Icon(item.icon, size: 20, color: AppColors.textPrimary),
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.timestamp,
                  style: AppTextStyles.footerText.copyWith(fontSize: 12),
                ),
                if (item.isUnread) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.unreadDot,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCheckCircle extends StatelessWidget {
  final bool isSelected;

  const _SelectionCheckCircle({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: isSelected ? null : Border.all(color: AppColors.border),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: AppColors.white)
          : null,
    );
  }
}