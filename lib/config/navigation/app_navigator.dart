import 'package:flutter/material.dart';
import 'package:ootd_ai/screens/dashboard/dashboard_screen.dart';
import 'package:ootd_ai/screens/closet/closet_screen.dart';
import 'package:ootd_ai/screens/laundry/laundry_screen.dart';
import 'package:ootd_ai/screens/outfit/outfit_screen.dart';
import 'package:ootd_ai/screens/history/history_screen.dart';

/// Navigation and routing for the app
class AppNavigator {
  /// Generate routes based on route name
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
      case '/closet':
        return MaterialPageRoute(
          builder: (_) => const ClosetScreen(),
          settings: settings,
        );
      case '/laundry':
        return MaterialPageRoute(
          builder: (_) => const LaundryScreen(),
          settings: settings,
        );
      case '/outfit':
        return MaterialPageRoute(
          builder: (_) => const OutfitScreen(),
          settings: settings,
        );
      case '/history':
        return MaterialPageRoute(
          builder: (_) => const HistoryScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
    }
  }

  /// Get initial route
  static const String initialRoute = '/';

  /// Route names
  static const String dashboard = '/';
  static const String closet = '/closet';
  static const String laundry = '/laundry';
  static const String outfit = '/outfit';
  static const String history = '/history';
}