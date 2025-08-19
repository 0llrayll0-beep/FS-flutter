import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImagePickerButtons extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseFromGallery;
  final bool isProcessing;

  const ImagePickerButtons({
    super.key,
    required this.onTakePhoto,
    required this.onChooseFromGallery,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Take Photo Button
          SizedBox(
            width: double.infinity,
            height: 7.h,
            child: ElevatedButton.icon(
              onPressed: isProcessing ? null : onTakePhoto,
              icon: CustomIconWidget(
                iconName: 'camera_alt',
                color: isProcessing
                    ? AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.38)
                    : AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text(
                'Take Photo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isProcessing
                          ? AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.38)
                          : AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isProcessing
                    ? AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.12)
                    : AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                elevation: isProcessing ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Choose from Gallery Button
          SizedBox(
            width: double.infinity,
            height: 7.h,
            child: OutlinedButton.icon(
              onPressed: isProcessing ? null : onChooseFromGallery,
              icon: CustomIconWidget(
                iconName: 'photo_library',
                color: isProcessing
                    ? AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.38)
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: Text(
                'Choose from Gallery',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isProcessing
                          ? AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.38)
                          : AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                side: BorderSide(
                  color: isProcessing
                      ? AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.12)
                      : AppTheme.lightTheme.colorScheme.primary,
                  width: 1.5,
                ),
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
