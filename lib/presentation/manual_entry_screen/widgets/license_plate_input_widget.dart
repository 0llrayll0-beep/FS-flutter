import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LicensePlateInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? errorText;
  final bool isLoading;

  const LicensePlateInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.errorText,
    this.isLoading = false,
  });

  @override
  State<LicensePlateInputWidget> createState() =>
      _LicensePlateInputWidgetState();
}

class _LicensePlateInputWidgetState extends State<LicensePlateInputWidget> {
  bool _isValid = true;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validatePlate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validatePlate);
    super.dispose();
  }

  void _validatePlate() {
    final text = widget.controller.text;
    if (text.isEmpty) {
      setState(() {
        _isValid = true;
        _validationMessage = null;
      });
      return;
    }

    // US license plate regex pattern (3-8 characters, alphanumeric)
    final plateRegex = RegExp(r'^[A-Z0-9]{3,8}$');
    final isValidFormat = plateRegex.hasMatch(text);

    setState(() {
      _isValid = isValidFormat;
      _validationMessage = isValidFormat
          ? null
          : 'Invalid plate format (3-8 alphanumeric characters)';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'License Plate *',
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
              color: widget.errorText != null || !_isValid
                  ? theme.colorScheme.error
                  : _isValid && widget.controller.text.isNotEmpty
                      ? AppTheme.successLight
                      : theme.colorScheme.outline.withValues(alpha: 0.5),
              width: widget.errorText != null || !_isValid ? 2.0 : 1.0,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            enabled: !widget.isLoading,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            maxLength: 8,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
              UpperCaseTextFormatter(),
            ],
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
              fontSize: 18.sp,
            ),
            decoration: InputDecoration(
              hintText: 'ABC1234',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                letterSpacing: 2.0,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'directions_car',
                  color: widget.errorText != null || !_isValid
                      ? theme.colorScheme.error
                      : _isValid && widget.controller.text.isNotEmpty
                          ? AppTheme.successLight
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
              suffixIcon: widget.isLoading
                  ? Padding(
                      padding: EdgeInsets.all(3.w),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                  : widget.controller.text.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: _isValid ? 'check_circle' : 'error',
                            color: _isValid
                                ? AppTheme.successLight
                                : theme.colorScheme.error,
                            size: 24,
                          ),
                        )
                      : null,
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
            onChanged: (value) {
              widget.onChanged(value);
              _validatePlate();
            },
          ),
        ),
        if (widget.errorText != null || _validationMessage != null) ...[
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
                    widget.errorText ?? _validationMessage ?? '',
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
        if (_isValid &&
            widget.controller.text.isNotEmpty &&
            widget.errorText == null) ...[
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle_outline',
                  color: AppTheme.successLight,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Valid license plate format',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
