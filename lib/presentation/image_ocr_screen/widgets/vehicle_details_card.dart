import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleDetailsCard extends StatelessWidget {
  final Map<String, dynamic> vehicleData;
  final bool showRegistrationForm;
  final VoidCallback? onRegisterVehicle;

  const VehicleDetailsCard({
    super.key,
    required this.vehicleData,
    this.showRegistrationForm = false,
    this.onRegisterVehicle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRegistered = vehicleData['isRegistered'] == true;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isRegistered ? 'Vehicle Found' : 'Vehicle Not Registered',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isRegistered
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isRegistered
                          ? AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: isRegistered ? 'check_circle' : 'error',
                          color: isRegistered
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.error,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          isRegistered ? 'Active' : 'Unregistered',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: isRegistered
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                    : AppTheme.lightTheme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Vehicle Details
              _buildDetailRow(
                context,
                'License Plate',
                (vehicleData['plate'] as String? ?? '').toUpperCase(),
                Icons.confirmation_number,
              ),

              if (isRegistered) ...[
                SizedBox(height: 2.h),
                _buildDetailRow(
                  context,
                  'Brand',
                  vehicleData['brand'] as String? ?? 'N/A',
                  Icons.business,
                ),
                SizedBox(height: 2.h),
                _buildDetailRow(
                  context,
                  'Model',
                  vehicleData['model'] as String? ?? 'N/A',
                  Icons.directions_car,
                ),
                SizedBox(height: 2.h),
                _buildDetailRow(
                  context,
                  'Year',
                  vehicleData['year']?.toString() ?? 'N/A',
                  Icons.calendar_today,
                ),
                SizedBox(height: 2.h),
                _buildDetailRow(
                  context,
                  'Status',
                  vehicleData['status'] as String? ?? 'N/A',
                  Icons.info,
                ),
              ],

              // Registration form or button for unregistered vehicles
              if (!isRegistered) ...[
                SizedBox(height: 3.h),
                if (showRegistrationForm)
                  _buildRegistrationForm(context)
                else
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton.icon(
                      onPressed: onRegisterVehicle,
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 20,
                      ),
                      label: Text(
                        'Register Vehicle',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: icon.toString().split('.').last,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Register New Vehicle',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),

          SizedBox(height: 2.h),

          // Brand Field
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Brand',
              hintText: 'Enter vehicle brand',
              prefixIcon: Icon(Icons.business),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Model Field
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Model',
              hintText: 'Enter vehicle model',
              prefixIcon: Icon(Icons.directions_car),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Year Field
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Year',
              hintText: 'Enter manufacturing year',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Status Dropdown
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Status',
              prefixIcon: Icon(Icons.info),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: ['Active', 'Inactive'].map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              );
            }).toList(),
            onChanged: (String? value) {
              // Handle status change
            },
          ),

          SizedBox(height: 3.h),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle save vehicle
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Vehicle registered successfully!'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                );
              },
              icon: CustomIconWidget(
                iconName: 'save',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 20,
              ),
              label: Text(
                'Save Vehicle',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onTertiary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
