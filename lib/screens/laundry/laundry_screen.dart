import 'package:flutter/material.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/services/clothing_service.dart';

/// Screen for managing clothing items in laundry
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
    _loadLaundry();
  }

  /// Load laundry items
  void _loadLaundry() {
    setState(() {
      _laundryList = _clothingService.getLaundryClothes();
    });
  }

  /// Mark item as ready
  void _markAsReady(ClothingItem item) {
    _clothingService.markAsAvailable(item.id);
    _loadLaundry();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} is ready!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Get remaining laundry days
  int _getRemainingDays(ClothingItem item) {
    return _clothingService.getRemainingLaundryDays(item.id);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry'),
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(context, colorScheme),
    );
  }

  /// Build main body
  Widget _buildBody(BuildContext context, ColorScheme colorScheme) {
    if (_laundryList.isEmpty) {
      return _buildEmptyState(context, colorScheme);
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadLaundry();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _laundryList.length,
        itemBuilder: (context, index) {
          return _buildLaundryCard(
            context,
            _laundryList[index],
            colorScheme,
          );
        },
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_laundry_service,
            size: 80,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 20),
          Text(
            'No Items in Laundry',
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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/closet');
            },
            icon: const Icon(Icons.checkroom),
            label: const Text('Go to Closet'),
          ),
        ],
      ),
    );
  }

  /// Build laundry card
  Widget _buildLaundryCard(
    BuildContext context,
    ClothingItem item,
    ColorScheme colorScheme,
  ) {
    final remainingDays = _getRemainingDays(item);
    final isReady = remainingDays <= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and status
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    isReady ? 'Ready!' : 'In Progress',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: isReady
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isReady ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remaining Days',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      remainingDays.toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: isReady ? 1.0 : (2 - remainingDays) / 2,
                    minHeight: 6,
                    backgroundColor: colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isReady ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Ready by date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ready by',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                ),
                Text(
                  item.laundryUntil != null
                      ? '${item.laundryUntil!.day}/${item.laundryUntil!.month}/${item.laundryUntil!.year}'
                      : 'N/A',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                ),
              ],
            ),

            // Mark as ready button
            if (isReady) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _markAsReady(item),
                  icon: const Icon(Icons.done),
                  label: const Text('Mark as Ready'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}