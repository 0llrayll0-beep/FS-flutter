import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleFormWidget extends StatefulWidget {
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final String selectedStatus;
  final Function(String) onStatusChanged;
  final Function(String) onBrandChanged;
  final Function(String) onModelChanged;
  final Function(String) onYearChanged;
  final bool isLoading;
  final Map<String, String?> errors;

  const VehicleFormWidget({
    super.key,
    required this.brandController,
    required this.modelController,
    required this.yearController,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onBrandChanged,
    required this.onModelChanged,
    required this.onYearChanged,
    this.isLoading = false,
    this.errors = const {},
  });

  @override
  State<VehicleFormWidget> createState() => _VehicleFormWidgetState();
}

class _VehicleFormWidgetState extends State<VehicleFormWidget> {
  final List<String> _statusOptions = ['Active', 'Inactive'];
  final List<String> _recentYears = _generateRecentYears();

  static List<String> _generateRecentYears() {
    final currentYear = DateTime.now().year;
    final years = <String>[];
    for (int i = currentYear; i >= currentYear - 30; i--) {
      years.add(i.toString());
    }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Brand Field
        _buildTextFormField(
          context: context,
          controller: widget.brandController,
          label: 'Brand *',
          hintText: 'e.g., Toyota, Ford, BMW',
          iconName: 'business',
          onChanged: widget.onBrandChanged,
          errorText: widget.errors['brand'],
          textCapitalization: TextCapitalization.words,
        ),

        SizedBox(height: 3.h),

        // Model Field
        _buildTextFormField(
          context: context,
          controller: widget.modelController,
          label: 'Model *',
          hintText: 'e.g., Camry, F-150, X3',
          iconName: 'directions_car_filled',
          onChanged: widget.onModelChanged,
          errorText: widget.errors['model'],
          textCapitalization: TextCapitalization.words,
        ),

        SizedBox(height: 3.h),

        // Year Field with Dropdown
        _buildYearField(context),

        SizedBox(height: 3.h),

        // Status Dropdown
        _buildStatusDropdown(context),
      ],
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hintText,
    required String iconName,
    required Function(String) onChanged,
    String? errorText,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? theme.colorScheme.error
                  : theme.colorScheme.outline.withValues(alpha: 0.5),
              width: errorText != null ? 2.0 : 1.0,
            ),
          ),
          child: TextFormField(
            controller: controller,
            enabled: !widget.isLoading,
            textCapitalization: textCapitalization,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: errorText != null
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error_outline',
                  color: theme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    errorText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildYearField(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Year *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            // Text Input
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.errors['year'] != null
                        ? theme.colorScheme.error
                        : theme.colorScheme.outline.withValues(alpha: 0.5),
                    width: widget.errors['year'] != null ? 2.0 : 1.0,
                  ),
                ),
                child: TextFormField(
                  controller: widget.yearController,
                  enabled: !widget.isLoading,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: '2024',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'calendar_today',
                        color: widget.errors['year'] != null
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 24,
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    counterText: '',
                  ),
                  onChanged: widget.onYearChanged,
                ),
              ),
            ),

            SizedBox(width: 2.w),

            // Dropdown Button
            Expanded(
              flex: 1,
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    icon: CustomIconWidget(
                      iconName: 'arrow_drop_down',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 24,
                    ),
                    items: _recentYears.map((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(
                          year,
                          style: theme.textTheme.bodyLarge,
                        ),
                      );
                    }).toList(),
                    onChanged: widget.isLoading
                        ? null
                        : (String? value) {
                            if (value != null) {
                              widget.yearController.text = value;
                              widget.onYearChanged(value);
                            }
                          },
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.errors['year'] != null) ...[
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error_outline',
                  color: theme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    widget.errors['year']!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: widget.selectedStatus.isEmpty ? null : widget.selectedStatus,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: widget.selectedStatus == 'Active'
                      ? 'check_circle'
                      : widget.selectedStatus == 'Inactive'
                          ? 'cancel'
                          : 'radio_button_unchecked',
                  color: widget.selectedStatus == 'Active'
                      ? AppTheme.successLight
                      : widget.selectedStatus == 'Inactive'
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
            hint: Text(
              'Select Status',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            items: _statusOptions.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: status == 'Active' ? 'check_circle' : 'cancel',
                      color: status == 'Active'
                          ? AppTheme.successLight
                          : theme.colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      status,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: widget.isLoading
                ? null
                : (String? value) {
                    if (value != null) {
                      widget.onStatusChanged(value);
                    }
                  },
            icon: CustomIconWidget(
              iconName: 'arrow_drop_down',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
