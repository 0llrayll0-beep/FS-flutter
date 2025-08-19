import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/license_plate_input_widget.dart';
import './widgets/save_update_button_widget.dart';
import './widgets/search_button_widget.dart';
import './widgets/vehicle_form_widget.dart';
import './widgets/vehicle_not_registered_widget.dart';

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  // Controllers
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // Form state
  String _selectedStatus = 'Active';
  bool _isSearching = false;
  bool _isSaving = false;
  bool _isUpdateMode = false;
  bool _showVehicleNotRegistered = false;
  String? _foundVehicleId;

  // Error handling
  Map<String, String?> _errors = {};

  // Mock Firestore data
  final List<Map<String, dynamic>> _mockVehicleDatabase = [
    {
      "id": "1",
      "licensePlate": "ABC1234",
      "brand": "Toyota",
      "model": "Camry",
      "year": "2022",
      "status": "Active",
      "createdAt": DateTime.now().subtract(const Duration(days: 30)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      "id": "2",
      "licensePlate": "XYZ5678",
      "brand": "Ford",
      "model": "F-150",
      "year": "2023",
      "status": "Active",
      "createdAt": DateTime.now().subtract(const Duration(days: 60)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      "id": "3",
      "licensePlate": "DEF9012",
      "brand": "BMW",
      "model": "X3",
      "year": "2021",
      "status": "Inactive",
      "createdAt": DateTime.now().subtract(const Duration(days: 90)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 15)),
    },
    {
      "id": "4",
      "licensePlate": "GHI3456",
      "brand": "Honda",
      "model": "Civic",
      "year": "2024",
      "status": "Active",
      "createdAt": DateTime.now().subtract(const Duration(days: 20)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      "id": "5",
      "licensePlate": "JKL7890",
      "brand": "Chevrolet",
      "model": "Silverado",
      "year": "2020",
      "status": "Active",
      "createdAt": DateTime.now().subtract(const Duration(days: 120)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 25)),
    },
  ];

  @override
  void dispose() {
    _licensePlateController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  // Search vehicle in mock database
  Future<void> _searchVehicle() async {
    if (_licensePlateController.text.trim().isEmpty) {
      _showErrorMessage('Por favor, digite um número de placa');
      return;
    }

    setState(() {
      _isSearching = true;
      _errors.clear();
      _showVehicleNotRegistered = false;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final searchPlate = _licensePlateController.text.trim().toUpperCase();
      final foundVehicle = _mockVehicleDatabase.firstWhere(
        (vehicle) =>
            (vehicle['licensePlate'] as String).toUpperCase() == searchPlate,
        orElse: () => {},
      );

      if (foundVehicle.isNotEmpty) {
        // Vehicle found - pre-fill form
        setState(() {
          _brandController.text = foundVehicle['brand'] as String;
          _modelController.text = foundVehicle['model'] as String;
          _yearController.text = foundVehicle['year'] as String;
          _selectedStatus = foundVehicle['status'] as String;
          _isUpdateMode = true;
          _foundVehicleId = foundVehicle['id'] as String;
          _showVehicleNotRegistered = false;
        });

        _showSuccessMessage(
            'Veículo encontrado! Dados carregados para edição.');
        HapticFeedback.lightImpact();
      } else {
        // Vehicle not found
        setState(() {
          _brandController.clear();
          _modelController.clear();
          _yearController.clear();
          _selectedStatus = 'Active';
          _isUpdateMode = false;
          _foundVehicleId = null;
          _showVehicleNotRegistered = true;
        });

        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      _showErrorMessage('Pesquisa falhou. Tente novamente.');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  // Save or update vehicle
  Future<void> _saveVehicle() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final vehicleData = {
        'licensePlate': _licensePlateController.text.trim().toUpperCase(),
        'brand': _brandController.text.trim(),
        'model': _modelController.text.trim(),
        'year': _yearController.text.trim(),
        'status': _selectedStatus,
        'updatedAt': DateTime.now(),
      };

      if (_isUpdateMode && _foundVehicleId != null) {
        // Update existing vehicle
        final index = _mockVehicleDatabase.indexWhere(
          (vehicle) => vehicle['id'] == _foundVehicleId,
        );
        if (index != -1) {
          _mockVehicleDatabase[index] = {
            ..._mockVehicleDatabase[index],
            ...vehicleData,
          };
        }
        _showSuccessMessage('Veículo atualizado com sucesso!');
      } else {
        // Add new vehicle
        final newVehicle = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          ...vehicleData,
          'createdAt': DateTime.now(),
        };
        _mockVehicleDatabase.add(newVehicle);
        _showSuccessMessage('Veículo salvo com sucesso!');
      }

      // Reset form
      _resetForm();
      HapticFeedback.heavyImpact();
    } catch (e) {
      _showErrorMessage('Falha ao salvar veículo. Tente novamente.');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  // Form validation
  bool _validateForm() {
    final errors = <String, String?>{};

    if (_licensePlateController.text.trim().isEmpty) {
      errors['licensePlate'] = 'Placa do veículo é obrigatória';
    } else {
      final plateRegex = RegExp(r'^[A-Z0-9]{3,8}$');
      if (!plateRegex
          .hasMatch(_licensePlateController.text.trim().toUpperCase())) {
        errors['licensePlate'] = 'Formato de placa inválido';
      }
    }

    if (_brandController.text.trim().isEmpty) {
      errors['brand'] = 'Marca é obrigatória';
    }

    if (_modelController.text.trim().isEmpty) {
      errors['model'] = 'Modelo é obrigatório';
    }

    if (_yearController.text.trim().isEmpty) {
      errors['year'] = 'Ano é obrigatório';
    } else {
      final year = int.tryParse(_yearController.text.trim());
      final currentYear = DateTime.now().year;
      if (year == null || year < 1900 || year > currentYear + 1) {
        errors['year'] = 'Digite um ano válido (1900-${currentYear + 1})';
      }
    }

    setState(() {
      _errors = errors;
    });

    return errors.isEmpty;
  }

  // Reset form
  void _resetForm() {
    setState(() {
      _licensePlateController.clear();
      _brandController.clear();
      _modelController.clear();
      _yearController.clear();
      _selectedStatus = 'Active';
      _isUpdateMode = false;
      _foundVehicleId = null;
      _showVehicleNotRegistered = false;
      _errors.clear();
    });
  }

  // Show success message
  void _showSuccessMessage(String message) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: AppTheme.successLight,
        textColor: Colors.white,
      );
    } else {
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
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Show error message
  void _showErrorMessage(String message) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Colors.white,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'error',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFormValid = _licensePlateController.text.trim().isNotEmpty &&
        _brandController.text.trim().isNotEmpty &&
        _modelController.text.trim().isNotEmpty &&
        _yearController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Entrada Manual',
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 2.0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios_new',
            color: theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onPrimary,
              size: 24,
            ),
            onPressed: _resetForm,
            tooltip: 'Redefinir Formulário',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Registro de Veículos',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                'Digite os detalhes do veículo manualmente ou pesquise registros existentes',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),

              SizedBox(height: 4.h),

              // License Plate Input
              LicensePlateInputWidget(
                controller: _licensePlateController,
                onChanged: (value) {
                  setState(() {
                    if (_errors.containsKey('licensePlate')) {
                      _errors.remove('licensePlate');
                    }
                    if (_showVehicleNotRegistered) {
                      _showVehicleNotRegistered = false;
                    }
                    if (_isUpdateMode) {
                      _isUpdateMode = false;
                      _foundVehicleId = null;
                      _brandController.clear();
                      _modelController.clear();
                      _yearController.clear();
                      _selectedStatus = 'Active';
                    }
                  });
                },
                errorText: _errors['licensePlate'],
                isLoading: _isSearching,
              ),

              SizedBox(height: 3.h),

              // Search Button
              SearchButtonWidget(
                onPressed: _searchVehicle,
                isLoading: _isSearching,
                isEnabled: _licensePlateController.text.trim().isNotEmpty,
              ),

              SizedBox(height: 4.h),

              // Vehicle Not Registered Message
              if (_showVehicleNotRegistered) ...[
                VehicleNotRegisteredWidget(
                  licensePlate:
                      _licensePlateController.text.trim().toUpperCase(),
                ),
                SizedBox(height: 4.h),
              ],

              // Form Section
              if (_showVehicleNotRegistered || _isUpdateMode) ...[
                // Section Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: _isUpdateMode ? 'edit' : 'add',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isUpdateMode
                                ? 'Atualizar Detalhes do Veículo'
                                : 'Registrar Novo Veículo',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            _isUpdateMode
                                ? 'Modifique as informações do veículo existente'
                                : 'Preencha as informações do veículo abaixo',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Vehicle Form
                VehicleFormWidget(
                  brandController: _brandController,
                  modelController: _modelController,
                  yearController: _yearController,
                  selectedStatus: _selectedStatus,
                  onStatusChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                  onBrandChanged: (value) {
                    setState(() {
                      if (_errors.containsKey('brand')) {
                        _errors.remove('brand');
                      }
                    });
                  },
                  onModelChanged: (value) {
                    setState(() {
                      if (_errors.containsKey('model')) {
                        _errors.remove('model');
                      }
                    });
                  },
                  onYearChanged: (value) {
                    setState(() {
                      if (_errors.containsKey('year')) {
                        _errors.remove('year');
                      }
                    });
                  },
                  isLoading: _isSaving,
                  errors: _errors,
                ),

                SizedBox(height: 4.h),

                // Save/Update Button
                SaveUpdateButtonWidget(
                  onPressed: _saveVehicle,
                  isLoading: _isSaving,
                  isEnabled: isFormValid && !_isSaving,
                  isUpdateMode: _isUpdateMode,
                ),
              ],

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: kBottomNavigationBarHeight + 8,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  icon: 'home_outlined',
                  activeIcon: 'home',
                  label: 'Início',
                  isSelected: false,
                  onTap: () => Navigator.pushReplacementNamed(
                      context, '/welcome-screen'),
                ),
                _buildNavItem(
                  context,
                  icon: 'camera_alt_outlined',
                  activeIcon: 'camera_alt',
                  label: 'Escanear',
                  isSelected: false,
                  onTap: () => Navigator.pushReplacementNamed(
                      context, '/image-ocr-screen'),
                ),
                _buildNavItem(
                  context,
                  icon: 'edit_outlined',
                  activeIcon: 'edit',
                  label: 'Manual',
                  isSelected: true,
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  icon: 'directions_car_outlined',
                  activeIcon: 'directions_car',
                  label: 'Detalhes',
                  isSelected: false,
                  onTap: () => Navigator.pushReplacementNamed(
                      context, '/vehicle-details-screen'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String icon,
    String? activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final Color itemColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: isSelected
                    ? BoxDecoration(
                        color: itemColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: CustomIconWidget(
                  iconName: isSelected ? (activeIcon ?? icon) : icon,
                  color: itemColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: itemColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
