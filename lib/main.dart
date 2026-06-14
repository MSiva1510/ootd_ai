import 'package:flutter/material.dart';
import 'package:ootd_ai/config/theme/app_theme.dart';
import 'package:ootd_ai/config/navigation/app_navigator.dart';
import 'package:ootd_ai/services/clothing_service.dart';
import 'package:ootd_ai/services/outfit_service.dart';

void main() {
  // Initialize all services as singletons (must be done before runApp)
  _initializeServices();
  
  runApp(const MainApp());
}

/// Initialize all application services
void _initializeServices() {
  // Access singleton instances to ensure they're created
  ClothingService();
  OutfitService();
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OOTD AI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppNavigator.initialRoute,
      onGenerateRoute: AppNavigator.onGenerateRoute,
    );
  }
}