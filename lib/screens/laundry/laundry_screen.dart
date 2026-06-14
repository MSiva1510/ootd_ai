import 'package:flutter/material.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/services/clothing_service.dart';

/// Laundry screen with auto-return and countdown timer
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

    // Refresh every second to update timers
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _loadLaundry();
      }
      return mounted;
    });
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

  /// Get remaining hours for display
  int _getRemainingHours(ClothingItem item) {
    return _clothingService.getRemainingLaundryHours(item.id);
  }

  /// Format remaining time
  String _formatRemainingTime(int hours) {
    if (hours <= 0) {
      return 'Ready!';
    } else if (hours >= 24) {
      return 'Ready in ${(hours / 24).toStringAsFixed(1)}d';
    } else {
      return 'Ready in ${hours}h';
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

  /// Build laundry card with countdown timer
  Widget _buildLaundryCard(
    BuildContext context,
    ClothingItem item,
    ColorScheme colorScheme,
  ) {
    final remainingHours = _getRemainingHours(item);
    final isReady = remainingHours <= 0;
    final progressValue = isReady ? 1.0 : ((24 - remainingHours) / 24);

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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReady
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isReady ? 'Ready!' : 'In Progress',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isReady ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Timer display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining Time',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatRemainingTime(remainingHours),
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isReady ? Colors.green : Colors.orange,
                              ),
                    ),
                  ],
                ),
                if (item.laundryUntil != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Ready By',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.laundryUntil!.day}/${item.laundryUntil!.month} ${item.laundryUntil!.hour}:${item.laundryUntil!.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                          ),
                    ),
                    Text(
                      '${(progressValue * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isReady ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Category and wear count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    item.category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Text(
                  'Worn ${item.wearCount}x',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 9,
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