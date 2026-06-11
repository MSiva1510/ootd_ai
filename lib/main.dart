import 'package:flutter/material.dart';

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
      body: _buildScreen(_selectedIndex),
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

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardPlaceholder();
      case 1:
        return const ClosetPlaceholder();
      case 2:
        return const LaundryPlaceholder();
      case 3:
        return const OutfitPlaceholder();
      case 4:
        return const HistoryPlaceholder();
      default:
        return const DashboardPlaceholder();
    }
  }
}

// ===== PLACEHOLDER SCREENS (Replace with actual screens) =====

class DashboardPlaceholder extends StatelessWidget {
  const DashboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Dashboard Screen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Replace with DashboardScreen'),
        ],
      ),
    );
  }
}

class ClosetPlaceholder extends StatelessWidget {
  const ClosetPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checkroom,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Closet Screen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Replace with ClosetScreen'),
        ],
      ),
    );
  }
}

class LaundryPlaceholder extends StatelessWidget {
  const LaundryPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_laundry_service,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Laundry Screen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Replace with LaundryScreen'),
        ],
      ),
    );
  }
}

class OutfitPlaceholder extends StatelessWidget {
  const OutfitPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.style,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Outfit Screen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Replace with OutfitScreen'),
        ],
      ),
    );
  }
}

class HistoryPlaceholder extends StatelessWidget {
  const HistoryPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'History Screen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Replace with HistoryScreen'),
        ],
      ),
    );
  }
}