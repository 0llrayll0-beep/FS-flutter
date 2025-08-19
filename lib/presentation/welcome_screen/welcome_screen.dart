import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/app_logo_widget.dart';
import './widgets/feature_highlights_widget.dart';
import './widgets/intro_text_widget.dart';

/// Welcome Screen - Home base for PlateScanner Pro application
/// Provides introduction to OCR functionality and quick navigation to main features
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  void _loadInitialData() {
    // Load any cached statistics or announcements
    // This would typically fetch from local storage or API
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Data loaded successfully
      }
    });
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();

    // Simulate refresh operation
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tela de boas-vindas atualizada'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Custom app bar section
              SliverToBoxAdapter(
                child: _buildAppBarSection(context),
              ),

              // Main content
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App logo and branding
                        const AppLogoWidget(),

                        // Introduction text
                        const IntroTextWidget(),

                        // Action buttons
                        const ActionButtonsWidget(),

                        // Feature highlights
                        const FeatureHighlightsWidget(),

                        // Bottom spacing for safe area
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Welcome text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem-vindo de volta!',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                _getGreeting(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Settings/Menu button
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: IconButton(
              onPressed: _showOptionsMenu,
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              tooltip: 'Options',
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bom Dia';
    } else if (hour < 17) {
      return 'Boa Tarde';
    } else {
      return 'Boa Noite';
    }
  }

  void _showOptionsMenu() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildOptionsBottomSheet(),
    );
  }

  Widget _buildOptionsBottomSheet() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 3.h),

          // Options list
          _buildOptionTile(
            icon: 'camera_alt',
            title: 'Escanear Veículo',
            subtitle: 'Use a câmera para escanear placas de veículos',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/image-ocr-screen');
            },
          ),

          _buildOptionTile(
            icon: 'edit',
            title: 'Entrada Manual',
            subtitle: 'Digite os detalhes do veículo manualmente',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/manual-entry-screen');
            },
          ),

          _buildOptionTile(
            icon: 'directions_car',
            title: 'Detalhes do Veículo',
            subtitle: 'Visualizar e gerenciar registros de veículos',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/vehicle-details-screen');
            },
          ),

          const Divider(height: 32),

          _buildOptionTile(
            icon: 'settings',
            title: 'Configurações',
            subtitle: 'Preferências e configuração do aplicativo',
            onTap: () {
              Navigator.pop(context);
              _showComingSoon('Configurações');
            },
          ),

          _buildOptionTile(
            icon: 'help',
            title: 'Ajuda e Suporte',
            subtitle: 'Obter ajuda e entrar em contato com o suporte',
            onTap: () {
              Navigator.pop(context);
              _showComingSoon('Ajuda e Suporte');
            },
          ),

          // Bottom safe area
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: theme.colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: theme.colorScheme.outline,
        size: 16,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0.5.h),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature em breve'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
