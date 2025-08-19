import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Feature highlights widget showcasing app capabilities
class FeatureHighlightsWidget extends StatelessWidget {
  const FeatureHighlightsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose PlateScanner Pro?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Feature cards grid
          _buildFeatureGrid(context),

          SizedBox(height: 2.h),

          // Trust indicators
          _buildTrustIndicators(context),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: 'camera_enhance',
                title: 'Smart OCR',
                description:
                    'processamento avançado usando tesseract',
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: 'cloud_done',
                title: 'Cloud Sync',
                description:
                    'Real-time database',
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: 'security',
                title: 'Secure',
                description:
                    'segurança contra DDos',
                color: Colors.orange,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: 'offline_bolt',
                title: 'Offline Ready',
                description: 'funciona sem conectar na internet',
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrustIndicators(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTrustItem(
            context,
            icon: 'verified_user',
            text: 'SSL Secured',
          ),
          _buildTrustItem(
            context,
            icon: 'cloud_circle',
            text: 'Firebase Powered',
          ),
          _buildTrustItem(
            context,
            icon: 'star',
            text: '4.8★ Rating',
          ),
        ],
      ),
    );
  }

  Widget _buildTrustItem(
    BuildContext context, {
    required String icon,
    required String text,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
