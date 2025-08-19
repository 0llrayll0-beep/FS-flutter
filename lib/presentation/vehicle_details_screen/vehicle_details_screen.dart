import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_section.dart';
import './widgets/vehicle_history_section.dart';
import './widgets/vehicle_info_card.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Map<String, dynamic>? _vehicleData;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock vehicle data
  final Map<String, dynamic> _mockVehicleData = {
    "id": "VH001",
    "plateNumber": "ABC-1234",
    "brand": "Toyota",
    "model": "Camry",
    "year": 2022,
    "status": "Active",
    "registrationDate": "2024-01-15",
    "lastUpdated": "2024-08-18",
    "owner": {
      "name": "John Smith",
      "phone": "+1 (555) 123-4567",
      "email": "john.smith@email.com"
    },
    "specifications": {
      "color": "Silver",
      "engineType": "Hybrid",
      "transmission": "Automatic",
      "fuelType": "Gasoline/Electric"
    },
    "notes": "verifique periodicamente"
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadVehicleData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadVehicleData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Simulate successful data loading
      setState(() {
        _vehicleData = _mockVehicleData;
        _isLoading = false;
      });

      _fadeController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage =
            'Falha ao carregar detalhes do veículo. Tente novamente.';
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: _vehicleData?['plateNumber'] ?? 'Detalhes do Veículo',
        showBackButton: true,
        actions: [
          if (_vehicleData != null)
            IconButton(
              onPressed: _refreshData,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: theme.appBarTheme.foregroundColor ??
                    theme.colorScheme.onPrimary,
                size: 24,
              ),
              tooltip: 'Atualizar',
            ),
        ],
      ),
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomBar(currentIndex: 3),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState(context);
    }

    if (_hasError) {
      return _buildErrorState(context);
    }

    if (_vehicleData == null) {
      return _buildEmptyState(context);
    }

    return _buildContentState(context);
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 15.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Carregando detalhes do veículo...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Aguarde enquanto buscamos as informações',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'error_outline',
                color: theme.colorScheme.error,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Não foi Possível Carregar Detalhes',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                    label: Text('Voltar'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _loadVehicleData,
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: theme.colorScheme.onPrimary,
                      size: 18,
                    ),
                    label: Text('Tentar Novamente'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'directions_car_outlined',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Nenhum Veículo Encontrado',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Os detalhes do veículo solicitado não puderam ser encontrados em nosso banco de dados.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed('/manual-entry-screen'),
              icon: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 18,
              ),
              label: Text('Adicionar Novo Veículo'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentState(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),

              // Vehicle Information Card
              VehicleInfoCard(vehicleData: _vehicleData!),

              // Action Buttons Section
              ActionButtonsSection(
                vehicleData: _vehicleData!,
                onEdit: _handleEditVehicle,
                onDelete: _handleDeleteVehicle,
              ),

              // Vehicle History Section
              VehicleHistorySection(vehicleData: _vehicleData!),

              // Additional Information Section
              _buildAdditionalInfoSection(context),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection(BuildContext context) {
    final theme = Theme.of(context);
    final specifications =
        _vehicleData!['specifications'] as Map<String, dynamic>;
    final owner = _vehicleData!['owner'] as Map<String, dynamic>;

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
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações Adicionais',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 3.h),

            // Specifications
            _buildInfoSubsection(
              context,
              title: 'Especificações do Veículo',
              icon: 'settings',
              items: [
                {'label': 'Cor', 'value': specifications['color']},
                {
                  'label': 'Tipo do Motor',
                  'value': specifications['engineType']
                },
                {
                  'label': 'Transmissão',
                  'value': specifications['transmission']
                },
                {
                  'label': 'Tipo de Combustível',
                  'value': specifications['fuelType']
                },
              ],
            ),

            SizedBox(height: 3.h),

            // Owner Information
            _buildInfoSubsection(
              context,
              title: 'Informações do Proprietário',
              icon: 'person',
              items: [
                {'label': 'Nome', 'value': owner['name']},
                {'label': 'Telefone', 'value': owner['phone']},
                {'label': 'Email', 'value': owner['email']},
              ],
            ),

            SizedBox(height: 3.h),

            // Notes
            if (_vehicleData!['notes'] != null) ...[
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'note',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Observações',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
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
                  _vehicleData!['notes'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSubsection(
    BuildContext context, {
    required String title,
    required String icon,
    required List<Map<String, dynamic>> items,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
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
          child: Column(
            children: items.map((item) {
              final isLast = item == items.last;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          item['label'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          item['value'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) ...[
                    SizedBox(height: 1.5.h),
                    Divider(
                      color: theme.dividerColor,
                      height: 1,
                    ),
                    SizedBox(height: 1.5.h),
                  ],
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    await _loadVehicleData();
  }

  void _handleEditVehicle() {
    HapticFeedback.lightImpact();

    // Navigate to manual entry screen with pre-filled data
    Navigator.of(context)
        .pushNamed(
      '/manual-entry-screen',
      arguments: _vehicleData,
    )
        .then((result) {
      // Refresh data if vehicle was updated
      if (result == true) {
        _refreshData();
      }
    });
  }

  void _handleDeleteVehicle() {
    HapticFeedback.mediumImpact();

    // Simulate deletion process
    _showDeletionProgress();
  }

  void _showDeletionProgress() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 15.w,
                height: 15.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.colorScheme.error),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Excluindo Veículo...',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Aguarde enquanto removemos o registro do veículo',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Simulate deletion delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close progress dialog

      // Show success message
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
              Text(
                  'Veículo "${_vehicleData!['plateNumber']}" excluído com sucesso'),
            ],
          ),
          backgroundColor: theme.colorScheme.tertiary,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      // Navigate back to welcome screen
      Navigator.of(context).pushReplacementNamed('/welcome-screen');
    });
  }
}
