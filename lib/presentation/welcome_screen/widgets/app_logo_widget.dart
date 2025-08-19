import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// App logo widget with vehicle iconography for PlateScanner Pro
class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          // Main logo container with gradient background
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background vehicle icon
                CustomIconWidget(
                  iconName: 'directions_car',
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                  size: 15.w,
                ),
                // Foreground scanner icon
                CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: theme.colorScheme.onPrimary,
                  size: 8.w,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // App name
          Text(
            'PlateScanner fortec',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Tagline
          Text(
            'projeto fortec',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
