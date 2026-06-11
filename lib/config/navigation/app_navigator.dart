import 'package:flutter/material.dart';
import 'package:ootd_ai/screens/dashboard/dashboard_screen.dart';
import 'package:ootd_ai/screens/closet/closet_screen.dart';
import 'package:ootd_ai/screens/laundry/laundry_screen.dart';
import 'package:ootd_ai/screens/outfit/outfit_screen.dart';
import 'package:ootd_ai/screens/history/history_screen.dart';


class AppNavigator {
  static const String dashboard = '/dashboard';
  static const String closet = '/closet';
  static const String laundry = '/laundry';
  static const String outfit = '/outfit';
  static const String history = '/history';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case closet:
        return MaterialPageRoute(builder: (_) => const ClosetScreen());
      case laundry:
        return MaterialPageRoute(builder: (_) => const LaundryScreen());
      case outfit:
        return MaterialPageRoute(builder: (_) => const OutfitScreen());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      default:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
    }
  }
}

