import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImagePreviewSection extends StatelessWidget {
  final dynamic selectedImage;
  final bool isProcessing;
  final VoidCallback? onProcessPlate;

  const ImagePreviewSection({
    super.key,
    this.selectedImage,
    this.isProcessing = false,
    this.onProcessPlate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Preview Container
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selectedImage != null
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: selectedImage != null
                  ? _buildImagePreview()
                  : _buildPlaceholder(context),
            ),
          ),

          // Process Plate Button
          if (selectedImage != null) ...[
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              height: 7.h,
              child: ElevatedButton(
                onPressed: isProcessing ? null : onProcessPlate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isProcessing
                      ? AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.12)
                      : AppTheme.lightTheme.colorScheme.tertiary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
                  elevation: isProcessing ? 0 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onTertiary
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Processing...',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onTertiary
                                      .withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme.lightTheme.colorScheme.onTertiary,
                            size: 24,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Process Plate',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onTertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    if (kIsWeb && selectedImage is List<int>) {
      return Image.memory(
        Uint8List.fromList(selectedImage as List<int>),
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (!kIsWeb && selectedImage is File) {
      return Image.file(
        selectedImage as File,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (selectedImage is String) {
      return CustomImageWidget(
        imageUrl: selectedImage as String,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
      );
    }

    return _buildPlaceholder(null);
  }

  Widget _buildPlaceholder(BuildContext? context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'image',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.4),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No image selected',
            style: context != null
                ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    )
                : TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Take a photo or choose from gallery',
            style: context != null
                ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                    )
                : TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}