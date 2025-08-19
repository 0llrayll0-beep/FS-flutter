import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class VehicleInfoCard extends StatelessWidget {
  final Map<String, dynamic> vehicleData;

  const VehicleInfoCard({
    super.key,
    required this.vehicleData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive =
        (vehicleData['status'] as String).toLowerCase() == 'active';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // License Plate Display
            _buildLicensePlateSection(context),

            SizedBox(height: 3.h),

            // Vehicle Details
            _buildDetailRow(
              context,
              icon: 'business',
              label: 'Brand',
              value: vehicleData['brand'] as String,
            ),

            SizedBox(height: 2.h),

            _buildDetailRow(
              context,
              icon: 'directions_car',
              label: 'Model',
              value: vehicleData['model'] as String,
            ),

            SizedBox(height: 2.h),

            _buildDetailRow(
              context,
              icon: 'calendar_today',
              label: 'Year',
              value: vehicleData['year'].toString(),
            ),

            SizedBox(height: 2.h),

            _buildStatusRow(context, isActive),

            SizedBox(height: 2.h),

            _buildRegistrationInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLicensePlateSection(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Text(
          vehicleData['plateNumber'] as String,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, bool isActive) {
    final theme = Theme.of(context);
    final statusColor = isActive
        ? theme.colorScheme.tertiary
        : theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: isActive ? 'check_circle' : 'cancel',
            color: statusColor,
            size: 20,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  vehicleData['status'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationInfo(BuildContext context) {
    final theme = Theme.of(context);
    final registrationDate =
        vehicleData['registrationDate'] as String? ?? 'Unknown';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registration Information',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'event',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Registered: $registrationDate',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'update',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Last Updated: ${DateTime.now().toString().substring(0, 10)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
