import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SaveUpdateButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final bool isUpdateMode;

  const SaveUpdateButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.isUpdateMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonText = isUpdateMode ? 'Update Vehicle' : 'Save Vehicle';
    final iconName = isUpdateMode ? 'update' : 'save';

    return Container(
      width: double.infinity,
      height: 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isEnabled
            ? LinearGradient(
                colors: [
                  AppTheme.successLight,
                  AppTheme.successLight.withValues(alpha: 0.8),
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
                  color: AppTheme.successLight.withValues(alpha: 0.3),
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
                  HapticFeedback.mediumImpact();
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
                        Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    isUpdateMode ? 'Updating...' : 'Saving...',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  CustomIconWidget(
                    iconName: iconName,
                    color: isEnabled
                        ? Colors.white
                        : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    buttonText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isEnabled
                          ? Colors.white
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
