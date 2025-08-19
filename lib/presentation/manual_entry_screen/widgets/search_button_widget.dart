import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  const SearchButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isEnabled
            ? LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: !isEnabled
            ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
            : null,
        boxShadow: isEnabled && !isLoading
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled && !isLoading
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed();
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Searching...',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  CustomIconWidget(
                    iconName: 'search',
                    color: isEnabled
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Search Vehicle',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isEnabled
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
