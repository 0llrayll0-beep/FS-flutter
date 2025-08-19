import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Action buttons widget for quick navigation to main features
class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          // Primary action - Scan License Plate
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToOCRScreen(context),
              icon: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text(
                'Escanear Placa de Veículo',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 3,
                shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Secondary action - Manual Entry
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton.icon(
              onPressed: () => _navigateToManualEntry(context),
              icon: CustomIconWidget(
                iconName: 'edit',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              label: Text(
                'Entrada Manual',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Quick stats or info section
          _buildQuickStats(context),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: 'speed',
            label: 'OCR Rápido',
            value: '< 2s',
          ),
          Container(
            width: 1,
            height: 4.h,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            context,
            icon: 'accuracy',
            label: 'Precisão',
            value: '99,5%',
          ),
          Container(
            width: 1,
            height: 4.h,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            context,
            icon: 'cloud_sync',
            label: 'Tempo Real',
            value: 'Sinc',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  void _navigateToOCRScreen(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/image-ocr-screen');
  }

  void _navigateToManualEntry(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/manual-entry-screen');
  }
}
