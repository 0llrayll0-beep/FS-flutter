import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ActionButtonsSection extends StatelessWidget {
  final Map<String, dynamic> vehicleData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActionButtonsSection({
    super.key,
    required this.vehicleData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Primary Actions Row
          Row(
            children: [
              Expanded(
                child: _buildEditButton(context),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDeleteButton(context),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Secondary Actions Row
          Row(
            children: [
              Expanded(
                child: _buildShareButton(context),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildCopyButton(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        onEdit();
      },
      icon: CustomIconWidget(
        iconName: 'edit',
        color: theme.colorScheme.onPrimary,
        size: 18,
      ),
      label: Text(
        'Edit Vehicle',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        _showDeleteConfirmation(context);
      },
      icon: CustomIconWidget(
        iconName: 'delete_outline',
        color: theme.colorScheme.error,
        size: 18,
      ),
      label: Text(
        'Delete',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.error,
        side: BorderSide(
          color: theme.colorScheme.error,
          width: 1.5,
        ),
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        _shareVehicleDetails(context);
      },
      icon: CustomIconWidget(
        iconName: 'share',
        color: theme.colorScheme.primary,
        size: 18,
      ),
      label: Text(
        'Share Details',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        _copyPlateNumber(context);
      },
      icon: CustomIconWidget(
        iconName: 'content_copy',
        color: theme.colorScheme.primary,
        size: 18,
      ),
      label: Text(
        'Copy Plate',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: theme.colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Delete Vehicle',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this vehicle record?',
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plate: ${vehicleData['plateNumber']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${vehicleData['brand']} ${vehicleData['model']} (${vehicleData['year']})',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'This action cannot be undone.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onError,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _shareVehicleDetails(BuildContext context) {
    final plateNumber = vehicleData['plateNumber'] as String;
    final brand = vehicleData['brand'] as String;
    final model = vehicleData['model'] as String;
    final year = vehicleData['year'].toString();
    final status = vehicleData['status'] as String;

    final shareText = '''
Vehicle Details:
Plate Number: $plateNumber
Brand: $brand
Model: $model
Year: $year
Status: $status

Shared from PlateScanner Pro
''';

    // Show share options
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);

        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 3.h),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Share Vehicle Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Container(
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
                child: Text(
                  shareText.trim(),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Clipboard.setData(ClipboardData(text: shareText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Vehicle details copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text('Copy to Clipboard'),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyPlateNumber(BuildContext context) {
    final plateNumber = vehicleData['plateNumber'] as String;

    Clipboard.setData(ClipboardData(text: plateNumber));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Plate number "$plateNumber" copied to clipboard'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
