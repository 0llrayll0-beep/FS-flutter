import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/image_picker_buttons.dart';
import './widgets/image_preview_section.dart';
import './widgets/vehicle_details_card.dart';

class ImageOcrScreen extends StatefulWidget {
  const ImageOcrScreen({super.key});

  @override
  State<ImageOcrScreen> createState() => _ImageOcrScreenState();
}

class _ImageOcrScreenState extends State<ImageOcrScreen>
    with TickerProviderStateMixin {
  final ImagePicker _imagePicker = ImagePicker();
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  dynamic _selectedImage;
  bool _isProcessing = false;
  bool _showVehicleDetails = false;
  bool _showRegistrationForm = false;
  Map<String, dynamic> _vehicleData = {};

  // Mock vehicle database
  final List<Map<String, dynamic>> _mockVehicleDatabase = [
    {
      "plate": "ABC123",
      "brand": "Toyota",
      "model": "Camry",
      "year": 2022,
      "status": "Active",
      "isRegistered": true,
    },
    {
      "plate": "XYZ789",
      "brand": "Honda",
      "model": "Civic",
      "year": 2021,
      "status": "Active",
      "isRegistered": true,
    },
    {
      "plate": "DEF456",
      "brand": "Ford",
      "model": "Focus",
      "year": 2020,
      "status": "Inactive",
      "isRegistered": true,
    },
    {
      "plate": "GHI789",
      "brand": "BMW",
      "model": "X5",
      "year": 2023,
      "status": "Active",
      "isRegistered": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!kIsWeb && await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          final camera = _cameras!.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
            orElse: () => _cameras!.first,
          );

          _cameraController = CameraController(
            camera,
            kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
          );

          await _cameraController!.initialize();
          await _applySettings();

          if (mounted) {
            setState(() {});
          }
        }
      }
    } catch (e) {
      debugPrint('Camera iniciada com erro: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode não suportado: $e');
        }
      }
    } catch (e) {
      debugPrint('erro nas configurações da camera: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      if (!kIsWeb &&
          _cameraController != null &&
          _cameraController!.value.isInitialized) {
        final XFile photo = await _cameraController!.takePicture();
        setState(() {
          _selectedImage = File(photo.path);
          _showVehicleDetails = false;
          _showRegistrationForm = false;
        });

        HapticFeedback.lightImpact();
      } else {
        // Fallback to image picker for web or if camera fails
        await _pickImageFromCamera();
      }
    } catch (e) {
      debugPrint('erro em tirar foto: $e');
      await _pickImageFromCamera();
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImage = bytes;
            _showVehicleDetails = false;
            _showRegistrationForm = false;
          });
        } else {
          setState(() {
            _selectedImage = File(image.path);
            _showVehicleDetails = false;
            _showRegistrationForm = false;
          });
        }

        HapticFeedback.lightImpact();
      }
    } catch (e) {
      debugPrint('erro em pegar a foto: $e');
      _showErrorSnackBar('Falha ao acessar câmera. Verifique as permissões.');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImage = bytes;
            _showVehicleDetails = false;
            _showRegistrationForm = false;
          });
        } else {
          setState(() {
            _selectedImage = File(image.path);
            _showVehicleDetails = false;
            _showRegistrationForm = false;
          });
        }

        HapticFeedback.lightImpact();
      }
    } catch (e) {
      debugPrint('erro em pegar a foto da galeria: $e');
      _showErrorSnackBar('Falha ao acessar galeria. Verifique as permissões.');
    }
  }

  Future<void> _processPlate() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    HapticFeedback.mediumImpact();

    try {
      // Simulate OCR processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock OCR result - simulate extracting plate number
      final List<String> mockPlateResults = [
        'ABC123',
        'XYZ789',
        'DEF456',
        'GHI789',
        'NEW001'
      ];
      final String detectedPlate = mockPlateResults[
          DateTime.now().millisecond % mockPlateResults.length];

      // Search in mock database
      final vehicleRecord = _mockVehicleDatabase.firstWhere(
        (vehicle) =>
            (vehicle['plate'] as String).toUpperCase() ==
            detectedPlate.toUpperCase(),
        orElse: () => {
          'plate': detectedPlate,
          'isRegistered': false,
        },
      );

      setState(() {
        _vehicleData = vehicleRecord;
        _showVehicleDetails = true;
        _showRegistrationForm = false;
        _isProcessing = false;
      });

      HapticFeedback.lightImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vehicleRecord['isRegistered'] == true
                ? 'Veículo encontrado no banco de dados!'
                : 'Placa detectada: ${detectedPlate.toUpperCase()}',
          ),
          backgroundColor: vehicleRecord['isRegistered'] == true
              ? AppTheme.lightTheme.colorScheme.tertiary
              : AppTheme.lightTheme.colorScheme.secondary,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      debugPrint('Erro de processamento OCR: $e');
      _showErrorSnackBar('Falha ao processar imagem. Tente novamente.');
    }
  }

  void _onRegisterVehicle() {
    setState(() {
      _showRegistrationForm = true;
    });

    HapticFeedback.lightImpact();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dispensar',
          textColor: AppTheme.lightTheme.colorScheme.onError,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Escanear Veículo'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  children: [
                    Text(
                      'Scanner de Placas de Veículos',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Tire uma foto ou selecione uma imagem para escanear placas de veículos',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Image Picker Buttons
              ImagePickerButtons(
                onTakePhoto: _takePhoto,
                onChooseFromGallery: _pickImageFromGallery,
                isProcessing: _isProcessing,
              ),

              // Image Preview Section
              ImagePreviewSection(
                selectedImage: _selectedImage,
                isProcessing: _isProcessing,
                onProcessPlate: _processPlate,
              ),

              // Vehicle Details Card
              if (_showVehicleDetails)
                VehicleDetailsCard(
                  vehicleData: _vehicleData,
                  showRegistrationForm: _showRegistrationForm,
                  onRegisterVehicle: _onRegisterVehicle,
                ),

              // Bottom spacing
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 1),
    );
  }
}
