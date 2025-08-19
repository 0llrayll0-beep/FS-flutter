import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class VehicleNotRegisteredWidget extends StatelessWidget {
  final String licensePlate;

  const VehicleNotRegisteredWidget({
    super.key,
    required this.licensePlate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'info_outline',
              color: theme.colorScheme.error,
              size: 32,
            ),
          ),

          SizedBox(height: 2.h),

          // Title
          Text(
            'Vehicle Not Registered',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // License plate display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              licensePlate,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          SizedBox(height: 1.5.h),

          // Description
          Text(
            'This license plate is not found in our database. Please fill out the form below to register this vehicle.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Action hint
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'arrow_downward',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Complete the form below',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
