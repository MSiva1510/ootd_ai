import 'package:flutter/material.dart';
import 'package:ootd_ai/config/theme/app_theme.dart';
import 'package:ootd_ai/config/theme/theme_controller.dart';
import 'package:ootd_ai/screens/closet/closet_screen.dart';
import 'package:ootd_ai/screens/dashboard/dashboard_screen.dart';
import 'package:ootd_ai/screens/laundry/laundry_screen.dart';
import 'package:ootd_ai/screens/outfit/outfit_screen.dart';
import 'package:ootd_ai/screens/history/history_screen.dart';

void main() {
  runApp(const OOTDAIApp());
}

class OOTDAIApp extends StatefulWidget {
  const OOTDAIApp({super.key});

  @override
  State<OOTDAIApp> createState() => _OOTDAIAppState();
}

class _OOTDAIAppState extends State<OOTDAIApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    _themeController.addListener(_onThemeChanged);
    _themeController.load();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _themeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OOTD AI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeController.themeMode,
      home: MainNavigation(themeController: _themeController),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  final ThemeController themeController;

  const MainNavigation({super.key, required this.themeController});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<String> _screenTitles = [
    'Dashboard',
    'Closet',
    'Laundry',
    'Outfit',
    'History',
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.checkroom_outlined,
    Icons.local_laundry_service_outlined,
    Icons.style_outlined,
    Icons.history_outlined,
  ];

  final List<IconData> _selectedIcons = [
    Icons.home,
    Icons.checkroom,
    Icons.local_laundry_service,
    Icons.style,
    Icons.history,
  ];

  late final List<Widget> _screens = [
    DashboardScreen(themeController: widget.themeController),
    const ClosetScreen(),
    const LaundryScreen(),
    const OutfitScreen(),
    const HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: List.generate(_screenTitles.length, (i) {
          return NavigationDestination(
            icon: Icon(_icons[i]),
            selectedIcon: Icon(_selectedIcons[i]),
            label: _screenTitles[i],
          );
        }),
      ),
    );
  }
}