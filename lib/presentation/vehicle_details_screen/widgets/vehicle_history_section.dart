import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class VehicleHistorySection extends StatefulWidget {
  final Map<String, dynamic> vehicleData;

  const VehicleHistorySection({
    super.key,
    required this.vehicleData,
  });

  @override
  State<VehicleHistorySection> createState() => _VehicleHistorySectionState();
}

class _VehicleHistorySectionState extends State<VehicleHistorySection> {
  bool _isExpanded = false;

  // Mock history data
  final List<Map<String, dynamic>> _historyData = [
    {
      "id": 1,
      "action": "Vehicle Registered",
      "date": "2024-01-15",
      "time": "10:30 AM",
      "user": "System Admin",
      "details": "Initial vehicle registration completed",
      "type": "registration"
    },
    {
      "id": 2,
      "action": "Status Updated",
      "date": "2024-03-22",
      "time": "2:15 PM",
      "user": "John Smith",
      "details": "Vehicle status changed to Active",
      "type": "status_change"
    },
    {
      "id": 3,
      "action": "Information Modified",
      "date": "2024-06-10",
      "time": "11:45 AM",
      "user": "Sarah Johnson",
      "details": "Updated vehicle model information",
      "type": "modification"
    },
    {
      "id": 4,
      "action": "OCR Scan",
      "date": "2024-08-18",
      "time": "9:20 AM",
      "user": "Mike Wilson",
      "details": "Vehicle scanned via OCR system",
      "type": "scan"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'history',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle History',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_historyData.length} records available',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            child: _isExpanded ? _buildHistoryContent(context) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
      child: Column(
        children: [
          Divider(
            color: theme.dividerColor,
            height: 1,
          ),

          SizedBox(height: 2.h),

          // History Timeline
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _historyData.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final historyItem = _historyData[index];
              final isLast = index == _historyData.length - 1;

              return _buildHistoryItem(context, historyItem, isLast);
            },
          ),

          SizedBox(height: 2.h),

          // View All Button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                _showFullHistoryDialog(context);
              },
              icon: CustomIconWidget(
                iconName: 'open_in_new',
                color: theme.colorScheme.primary,
                size: 18,
              ),
              label: Text(
                'View Complete History',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
      BuildContext context, Map<String, dynamic> item, bool isLast) {
    final theme = Theme.of(context);
    final type = item['type'] as String;

    Color getTypeColor() {
      switch (type) {
        case 'registration':
          return theme.colorScheme.tertiary;
        case 'status_change':
          return theme.colorScheme.primary;
        case 'modification':
          return Colors.orange;
        case 'scan':
          return Colors.purple;
        default:
          return theme.colorScheme.onSurface.withValues(alpha: 0.6);
      }
    }

    String getTypeIcon() {
      switch (type) {
        case 'registration':
          return 'app_registration';
        case 'status_change':
          return 'toggle_on';
        case 'modification':
          return 'edit';
        case 'scan':
          return 'qr_code_scanner';
        default:
          return 'circle';
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: getTypeColor(),
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 6.h,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                color: theme.dividerColor,
              ),
          ],
        ),

        SizedBox(width: 4.w),

        // Content
        Expanded(
          child: Container(
            padding: EdgeInsets.all(3.w),
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
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: getTypeIcon(),
                      color: getTypeColor(),
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        item['action'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  item['details'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${item['date']} at ${item['time']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    CustomIconWidget(
                      iconName: 'person',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      item['user'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFullHistoryDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 90.w,
            height: 70.h,
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'history',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Complete Vehicle History',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: ListView.separated(
                    itemCount: _historyData.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final historyItem = _historyData[index];
                      final isLast = index == _historyData.length - 1;

                      return _buildHistoryItem(context, historyItem, isLast);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
