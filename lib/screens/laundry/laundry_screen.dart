import 'package:flutter/material.dart';
import 'package:ootd_ai/services/clothing_service.dart';
import 'package:ootd_ai/models/clothing_item.dart';

/// Laundry screen for tracking items in laundry
class LaundryScreen extends StatefulWidget {
  const LaundryScreen({Key? key}) : super(key: key);

  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  late ClothingService _clothingService;
  List<ClothingItem> _laundryList = [];

  @override
  void initState() {
    super.initState();
    _clothingService = ClothingService();
    _loadLaundryItems();
  }

  /// Load laundry items from service
  void _loadLaundryItems() {
    setState(() {
      _laundryList = _clothingService.getLaundryClothes();
    });
  }

  /// Mark item as available (laundry done)
  void _markAsAvailable(String itemId, String itemName) {
    final success = _clothingService.markAsAvailable(itemId);
    if (success) {
      _loadLaundryItems();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$itemName is ready to wear!'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry'),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${_laundryList.length} items',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(context, colorScheme),
    );
  }

  /// Build the main body of the screen
  Widget _buildBody(BuildContext context, ColorScheme colorScheme) {
    if (_laundryList.isEmpty) {
      return _buildEmptyState(context, colorScheme);
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadLaundryItems();
        return Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            _buildSummaryCard(
              context,
              'Items in Laundry',
              _laundryList.length.toString(),
              Icons.local_laundry_service,
              Colors.orange,
            ),
            const SizedBox(height: 24),

            // Laundry list
            Text(
              'Laundry Queue',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            // List of laundry items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _laundryList.length,
              itemBuilder: (context, index) {
                return _buildLaundryCard(
                  context,
                  _laundryList[index],
                  colorScheme,
                  index,
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_laundry_service_outlined,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Laundry',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'All your clothes are clean!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              // Navigate to closet to add clothes to laundry
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.checkroom),
            label: const Text('Go to Closet'),
          ),
        ],
      ),
    );
  }

  /// Build summary card widget
  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual laundry card
  Widget _buildLaundryCard(
    BuildContext context,
    ClothingItem item,
    ColorScheme colorScheme,
    int index,
  ) {
    final remainingDays = _clothingService.getRemainingLaundryDays(item.id);
    final isAlmostReady = remainingDays <= 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with item number
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.category,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Laundry timeline
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 18,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Remaining Time',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$remainingDays day${remainingDays != 1 ? 's' : ''}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                            ),
                            if (item.laundryUntil != null)
                              Text(
                                'Ready: ${item.laundryUntil!.day}/${item.laundryUntil!.month}/${item.laundryUntil!.year}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: colorScheme.outline,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      // Progress indicator
                      if (item.laundryUntil != null)
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: _getProgressValue(
                                    item.dateAdded,
                                    item.laundryUntil!,
                                  ),
                                  strokeWidth: 3,
                                  color: isAlmostReady
                                      ? Colors.green
                                      : Colors.orange,
                                  backgroundColor:
                                      Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              Text(
                                '$remainingDays',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isAlmostReady
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Action button
            if (isAlmostReady)
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () => _markAsAvailable(item.id, item.name),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Mark as Ready',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'In Laundry',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Calculate progress value for circular progress indicator
  double _getProgressValue(DateTime startDate, DateTime endDate) {
    final total = endDate.difference(startDate).inDays;
    final remaining = endDate.difference(DateTime.now()).inDays;

    if (total <= 0) return 1.0;
    final progress = 1.0 - (remaining / total);
    return progress.clamp(0.0, 1.0);
  }
}
