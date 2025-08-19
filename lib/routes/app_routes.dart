import 'package:flutter/material.dart';
import '../presentation/image_ocr_screen/image_ocr_screen.dart';
import '../presentation/manual_entry_screen/manual_entry_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/vehicle_details_screen/vehicle_details_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String imageOcr = '/image-ocr-screen';
  static const String manualEntry = '/manual-entry-screen';
  static const String welcome = '/welcome-screen';
  static const String vehicleDetails = '/vehicle-details-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const WelcomeScreen(),
    imageOcr: (context) => const ImageOcrScreen(),
    manualEntry: (context) => const ManualEntryScreen(),
    welcome: (context) => const WelcomeScreen(),
    vehicleDetails: (context) => const VehicleDetailsScreen(),
    // TODO: Add your other routes here
  };
}
