import 'package:flutter/material.dart';
import 'package:ootd_ai/screens/closet/closet_screen.dart';
import 'package:ootd_ai/screens/dashboard/dashboard_screen.dart';
import 'package:ootd_ai/screens/laundry/laundry_screen.dart';
import 'package:ootd_ai/screens/outfit/outfit_screen.dart';
import 'package:ootd_ai/screens/history/history_screen.dart';

void main() {
  runApp(const OOTDAIApp());
}

class OOTDAIApp extends StatelessWidget {
  const OOTDAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OOTD AI',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

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

  // List of screens - using real screens now
  final List<Widget> _screens = [
    const DashboardScreen(),
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
      appBar: AppBar(
        title: Text(_screenTitles[_selectedIndex]),
        centerTitle: true,
        elevation: 0,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Icon(_icons[0]),
            selectedIcon: Icon(_selectedIcons[0]),
            label: _screenTitles[0],
          ),
          NavigationDestination(
            icon: Icon(_icons[1]),
            selectedIcon: Icon(_selectedIcons[1]),
            label: _screenTitles[1],
          ),
          NavigationDestination(
            icon: Icon(_icons[2]),
            selectedIcon: Icon(_selectedIcons[2]),
            label: _screenTitles[2],
          ),
          NavigationDestination(
            icon: Icon(_icons[3]),
            selectedIcon: Icon(_selectedIcons[3]),
            label: _screenTitles[3],
          ),
          NavigationDestination(
            icon: Icon(_icons[4]),
            selectedIcon: Icon(_selectedIcons[4]),
            label: _screenTitles[4],
          ),
        ],
      ),
    );
  }
}