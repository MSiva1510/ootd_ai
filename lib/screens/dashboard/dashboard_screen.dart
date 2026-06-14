import 'package:flutter/material.dart';
import 'package:ootd_ai/services/clothing_service.dart';
import 'package:ootd_ai/services/outfit_service.dart';

/// Dashboard screen showing overview and statistics
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ClothingService _clothingService;
  late OutfitService _outfitService;

  @override
  void initState() {
    super.initState();
    // Use singleton instances
    _clothingService = ClothingService();
    _outfitService = OutfitService();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Get live counts from services
    final totalClothing = _clothingService.getTotalCount();
    final availableClothing = _clothingService.getAvailableCount();
    final laundryClothing = _clothingService.getLaundryCount();
    final totalOutfits = _outfitService.getHistoryCount();
    final currentOutfit = _outfitService.getTodaysOutfit();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Text(
              'Welcome to OOTD AI',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your personal outfit recommendation assistant',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),

            const SizedBox(height: 32),

            // Closet overview
            Text(
              'Your Closet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    colorScheme,
                    'Total Items',
                    totalClothing.toString(),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    colorScheme,
                    'Available',
                    availableClothing.toString(),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    colorScheme,
                    'In Laundry',
                    laundryClothing.toString(),
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Outfit overview
            Text(
              'Outfits',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _buildOutfitCard(
              context,
              colorScheme,
              'Total Generated',
              totalOutfits.toString(),
              Icons.checkroom,
            ),

            const SizedBox(height: 12),

            if (currentOutfit != null)
              _buildOutfitCard(
                context,
                colorScheme,
                'Today\'s Outfit',
                'Ready',
                Icons.done,
              )
            else
              _buildOutfitCard(
                context,
                colorScheme,
                'Today\'s Outfit',
                'Generate',
                Icons.add,
              ),

            const SizedBox(height: 32),

            // Quick actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/closet');
                    },
                    icon: const Icon(Icons.checkroom),
                    label: const Text('Closet'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/outfit');
                    },
                    icon: const Icon(Icons.style),
                    label: const Text('Outfit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/history');
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('History'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/laundry');
                    },
                    icon: const Icon(Icons.local_laundry_service),
                    label: const Text('Laundry'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Build stat card
  Widget _buildStatCard(
    BuildContext context,
    ColorScheme colorScheme,
    String label,
    String value,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build outfit card
  Widget _buildOutfitCard(
    BuildContext context,
    ColorScheme colorScheme,
    String label,
    String status,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}