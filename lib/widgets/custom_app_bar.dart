import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom AppBar widget optimized for vehicle recognition application
/// Provides consistent navigation and branding across all screens
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (automatically determined if not specified)
  final bool? showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom background color (uses theme primary color if not specified)
  final Color? backgroundColor;

  /// Custom foreground color (uses theme onPrimary color if not specified)
  final Color? foregroundColor;

  /// Elevation of the app bar
  final double elevation;

  /// Whether to show a bottom border
  final bool showBottomBorder;

  /// Custom bottom widget (like TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.showBottomBorder = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Determine if we should show back button
    final bool shouldShowBackButton =
        showBackButton ?? (ModalRoute.of(context)?.canPop ?? false);

    return AppBar(
      title: Text(
        title,
        style: theme.appBarTheme.titleTextStyle?.copyWith(
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      leading:
          leading ?? (shouldShowBackButton ? _buildBackButton(context) : null),
      actions: actions ?? _buildDefaultActions(context),
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      shape: showBottomBorder
          ? const Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 0.5,
              ),
            )
          : null,
    );
  }

  /// Builds the back button with proper navigation
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () => _handleBackNavigation(context),
      tooltip: 'Back',
    );
  }

  /// Handles back navigation with proper route management
  void _handleBackNavigation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // If no previous route, navigate to welcome screen
      Navigator.of(context).pushReplacementNamed('/welcome-screen');
    }
  }

  /// Builds default actions for the app bar
  List<Widget> _buildDefaultActions(BuildContext context) {
    return [
      // Settings/Menu button
      IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => _showOptionsMenu(context),
        tooltip: 'Options',
      ),
    ];
  }

  /// Shows options menu with common actions
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _OptionsBottomSheet(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// Bottom sheet widget for app bar options
class _OptionsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Options list
          _buildOptionTile(
            context,
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/welcome-screen',
                (route) => false,
              );
            },
          ),

          _buildOptionTile(
            context,
            icon: Icons.camera_alt_outlined,
            title: 'Scan Vehicle',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/image-ocr-screen');
            },
          ),

          _buildOptionTile(
            context,
            icon: Icons.edit_outlined,
            title: 'Manual Entry',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/manual-entry-screen');
            },
          ),

          _buildOptionTile(
            context,
            icon: Icons.info_outline,
            title: 'Vehicle Details',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/vehicle-details-screen');
            },
          ),

          const Divider(height: 32),

          _buildOptionTile(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.of(context).pop();
              // Navigate to settings when implemented
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          _buildOptionTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.of(context).pop();
              // Navigate to help when implemented
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help & Support coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}

/// Factory methods for common app bar configurations
extension CustomAppBarFactory on CustomAppBar {
  /// Creates an app bar for the welcome screen
  static CustomAppBar welcome() {
    return const CustomAppBar(
      title: 'Vehicle Recognition',
      showBackButton: false,
    );
  }

  /// Creates an app bar for the OCR screen
  static CustomAppBar ocrScreen() {
    return const CustomAppBar(
      title: 'Scan Vehicle',
      showBackButton: true,
    );
  }

  /// Creates an app bar for the manual entry screen
  static CustomAppBar manualEntry() {
    return const CustomAppBar(
      title: 'Manual Entry',
      showBackButton: true,
    );
  }

  /// Creates an app bar for the vehicle details screen
  static CustomAppBar vehicleDetails() {
    return const CustomAppBar(
      title: 'Vehicle Details',
      showBackButton: true,
    );
  }

  /// Creates an app bar with custom actions
  static CustomAppBar withActions({
    required String title,
    required List<Widget> actions,
    bool showBackButton = true,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
    );
  }

  /// Creates an app bar with tabs
  static CustomAppBar withTabs({
    required String title,
    required TabBar tabBar,
    bool showBackButton = true,
  }) {
    return CustomAppBar(
      title: title,
      bottom: tabBar,
      showBackButton: showBackButton,
    );
  }
}
