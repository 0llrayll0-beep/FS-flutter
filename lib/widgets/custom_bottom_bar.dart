import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Navigation item data class
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom Bottom Navigation Bar optimized for vehicle recognition application
/// Provides quick access to main application features with haptic feedback
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when item is tapped
  final ValueChanged<int>? onTap;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  /// Whether to show labels
  final bool showLabels;

  /// Elevation of the bottom bar
  final double elevation;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  /// Navigation items for the bottom bar
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/welcome-screen',
    ),
    BottomNavItem(
      icon: Icons.camera_alt_outlined,
      activeIcon: Icons.camera_alt,
      label: 'Scanner',
      route: '/image-ocr-screen',
    ),
    BottomNavItem(
      icon: Icons.edit_outlined,
      activeIcon: Icons.edit,
      label: 'Manual',
      route: '/manual-entry-screen',
    ),
    BottomNavItem(
      icon: Icons.directions_car_outlined,
      activeIcon: Icons.directions_car,
      label: 'Detalhes',
      route: '/vehicle-details-screen',
    ),
  ];

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showLabels = true,
    this.elevation = 8.0,
    this.enableHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(26),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: kBottomNavigationBarHeight + (showLabels ? 8 : 0),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavItem(
                context,
                item: item,
                isSelected: isSelected,
                onTap: () => _handleItemTap(context, index, item.route),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Builds individual navigation item
  Widget _buildNavItem(
    BuildContext context, {
    required BottomNavItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color itemColor = isSelected
        ? (selectedItemColor ??
            theme.bottomNavigationBarTheme.selectedItemColor ??
            colorScheme.primary)
        : (unselectedItemColor ??
            theme.bottomNavigationBarTheme.unselectedItemColor ??
            colorScheme.onSurface.withAlpha(153));

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with selection indicator
              Container(
                padding: const EdgeInsets.all(8),
                decoration: isSelected
                    ? BoxDecoration(
                        color: itemColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  color: itemColor,
                  size: 24,
                ),
              ),

              // Label
              if (showLabels) ...[
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: itemColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Handles item tap with navigation and haptic feedback
  void _handleItemTap(BuildContext context, int index, String route) {
    // Provide haptic feedback
    if (enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Call custom onTap if provided
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Default navigation behavior
    if (index != currentIndex) {
      _navigateToRoute(context, route);
    }
  }

  /// Navigates to the specified route
  void _navigateToRoute(BuildContext context, String route) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute != route) {
      // Use pushReplacementNamed to replace current route
      // This prevents building up a large navigation stack
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  /// Gets the current index based on the current route
  static int getCurrentIndex(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    for (int i = 0; i < _navItems.length; i++) {
      if (_navItems[i].route == currentRoute) {
        return i;
      }
    }

    return 0; // Default to home if route not found
  }

  /// Creates a bottom bar with automatic current index detection
  static CustomBottomBar auto(BuildContext context) {
    return CustomBottomBar(
      currentIndex: getCurrentIndex(context),
    );
  }
}

/// Extension for easy integration with Scaffold
extension ScaffoldBottomBar on Scaffold {
  /// Creates a Scaffold with CustomBottomBar
  static Scaffold withCustomBottomBar({
    Key? key,
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    required BuildContext context,
    int? currentIndex,
    ValueChanged<int>? onBottomNavTap,
  }) {
    return Scaffold(
      key: key,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex ?? CustomBottomBar.getCurrentIndex(context),
        onTap: onBottomNavTap,
      ),
    );
  }
}

/// Mixin for screens that use CustomBottomBar
mixin BottomBarScreen<T extends StatefulWidget> on State<T> {
  int get currentBottomBarIndex;

  void onBottomBarTap(int index) {
    final route = CustomBottomBar._navItems[index].route;
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  CustomBottomBar buildBottomBar() {
    return CustomBottomBar(
      currentIndex: currentBottomBarIndex,
      onTap: onBottomBarTap,
    );
  }
}

/// Factory methods for common bottom bar configurations
extension CustomBottomBarFactory on CustomBottomBar {
  /// Creates a bottom bar for the welcome screen
  static CustomBottomBar welcome() {
    return const CustomBottomBar(currentIndex: 0);
  }

  /// Creates a bottom bar for the OCR screen
  static CustomBottomBar ocrScreen() {
    return const CustomBottomBar(currentIndex: 1);
  }

  /// Creates a bottom bar for the manual entry screen
  static CustomBottomBar manualEntry() {
    return const CustomBottomBar(currentIndex: 2);
  }

  /// Creates a bottom bar for the vehicle details screen
  static CustomBottomBar vehicleDetails() {
    return const CustomBottomBar(currentIndex: 3);
  }

  /// Creates a bottom bar with custom styling
  static CustomBottomBar styled({
    required int currentIndex,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    bool showLabels = true,
    double elevation = 8.0,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      showLabels: showLabels,
      elevation: elevation,
    );
  }
}
