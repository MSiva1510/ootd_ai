import 'package:flutter/material.dart';
import 'package:ootd_ai/services/clothing_service.dart';
import 'package:ootd_ai/services/outfit_service.dart';

/// Dashboard screen with analytics and wardrobe insights
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
    _clothingService = ClothingService();
    _outfitService = OutfitService();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Get live counts
    final totalClothing = _clothingService.getTotalCount();
    final availableClothing = _clothingService.getAvailableCount();
    final laundryClothing = _clothingService.getLaundryCount();
    final totalOutfits = _outfitService.getHistoryCount();
    final mostWornItem = _clothingService.getMostWornItem();
    final leastWornItem = _clothingService.getLeastWornItem();
    final totalWearCount = _clothingService.getTotalWearCount();
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
              'Outfit Generation',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildOutfitCard(
                    context,
                    colorScheme,
                    'Total Generated',
                    totalOutfits.toString(),
                    Icons.checkroom,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOutfitCard(
                    context,
                    colorScheme,
                    'Today\'s Outfit',
                    currentOutfit != null ? 'Ready' : 'Generate',
                    currentOutfit != null ? Icons.done : Icons.add,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Wardrobe Analytics
            Text(
              'Wardrobe Analytics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            // Most worn item
            if (mostWornItem != null)
              _buildAnalyticsCard(
                context,
                colorScheme,
                '👕 Most Worn Item',
                mostWornItem.name,
                '${mostWornItem.wearCount}x worn',
                Colors.purple,
              )
            else
              _buildAnalyticsCard(
                context,
                colorScheme,
                '👕 Most Worn Item',
                'No data yet',
                'Start generating outfits',
                Colors.grey,
              ),

            const SizedBox(height: 8),

            // Least worn item
            if (leastWornItem != null && totalClothing > 1)
              _buildAnalyticsCard(
                context,
                colorScheme,
                '🧥 Least Worn Item',
                leastWornItem.name,
                '${leastWornItem.wearCount}x worn',
                Colors.cyan,
              )
            else if (totalClothing == 0)
              _buildAnalyticsCard(
                context,
                colorScheme,
                '🧥 Least Worn Item',
                'Add more items',
                'Build your wardrobe',
                Colors.grey,
              ),

            const SizedBox(height: 8),

            // Total wear count
            _buildAnalyticsCard(
              context,
              colorScheme,
              '📊 Total Wear Count',
              totalWearCount.toString(),
              'across all items',
              Colors.indigo,
            ),

            const SizedBox(height: 32),

            // Wardrobe Insights
            Text(
              'Wardrobe Insights',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            ..._buildInsights(
              context,
              colorScheme,
              mostWornItem,
              leastWornItem,
              totalClothing,
              laundryClothing,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build analytics card
  Widget _buildAnalyticsCard(
    BuildContext context,
    ColorScheme colorScheme,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.trending_up,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          color: colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build insights
  List<Widget> _buildInsights(
    BuildContext context,
    ColorScheme colorScheme,
    dynamic mostWornItem,
    dynamic leastWornItem,
    int totalClothing,
    int laundryClothing,
  ) {
    final insights = <Widget>[];

    // Most worn insight
    if (mostWornItem != null) {
      insights.add(
        _buildInsightCard(
          context,
          colorScheme,
          '💡 Favorite Piece',
          '${mostWornItem.name} is your most used item (${mostWornItem.wearCount}x)',
          Colors.purple,
        ),
      );
      insights.add(const SizedBox(height: 8));
    }

    // Laundry insight
    if (laundryClothing > 0) {
      insights.add(
        _buildInsightCard(
          context,
          colorScheme,
          '🧺 Laundry Status',
          '$laundryClothing item${laundryClothing == 1 ? '' : 's'} in laundry - will return automatically',
          Colors.orange,
        ),
      );
      insights.add(const SizedBox(height: 8));
    }

    // Wardrobe size insight
    if (totalClothing < 5) {
      insights.add(
        _buildInsightCard(
          context,
          colorScheme,
          '👕 Build Your Wardrobe',
          'Add ${5 - totalClothing} more items for better outfit variety',
          Colors.blue,
        ),
      );
      insights.add(const SizedBox(height: 8));
    } else if (totalClothing >= 10) {
      insights.add(
        _buildInsightCard(
          context,
          colorScheme,
          '🎯 Great Collection',
          'You have $totalClothing items! Great outfit variety',
          Colors.green,
        ),
      );
      insights.add(const SizedBox(height: 8));
    }

    // No insights message
    if (insights.isEmpty) {
      insights.add(
        _buildInsightCard(
          context,
          colorScheme,
          '📝 Getting Started',
          'Generate outfits to unlock personalized insights',
          Colors.grey,
        ),
      );
    }

    return insights;
  }

  /// Build insight card
  Widget _buildInsightCard(
    BuildContext context,
    ColorScheme colorScheme,
    String title,
    String message,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}