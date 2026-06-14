import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/screens/closet/add_clothing_screen.dart';
import 'package:ootd_ai/services/clothing_service.dart';

/// Screen for displaying and managing the user's clothing closet
class ClosetScreen extends StatefulWidget {
  const ClosetScreen({Key? key}) : super(key: key);

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  late ClothingService _clothingService;
  List<ClothingItem> _clothingList = [];

  @override
  void initState() {
    super.initState();
    _clothingService = ClothingService();
    _loadClothing();
  }

  /// Load clothing items
  void _loadClothing() {
    setState(() {
      _clothingList = _clothingService.getAllClothes();
    });
  }

  /// Mark item as worn
  void _markAsWorn(ClothingItem item) {
    _clothingService.markAsWorn(item.id);
    _loadClothing();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} marked as worn'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Show item details in bottom sheet
  void _showItemDetails(BuildContext context, ClothingItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 24.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Image if available
                if (item.imagePath != null && item.imagePath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(item.imagePath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder(context);
                      },
                    ),
                  )
                else
                  _buildPlaceholder(context),

                const SizedBox(height: 16),

                // Details
                _buildDetailRow(context, 'Category', item.category),
                const SizedBox(height: 12),
                _buildDetailRow(context, 'Color', item.color),
                const SizedBox(height: 12),
                _buildDetailRow(context, 'Status', item.status),
                const SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  'Added',
                  '${item.dateAdded.day}/${item.dateAdded.month}/${item.dateAdded.year}',
                ),

                // Laundry status if in laundry
                if (item.status == 'In Laundry' && item.laundryUntil != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    'Ready by',
                    '${item.laundryUntil!.day}/${item.laundryUntil!.month}/${item.laundryUntil!.year}',
                  ),
                ],

                const SizedBox(height: 24),

                // Action button
                if (item.status == 'Available')
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _markAsWorn(item);
                      },
                      child: const Text('Mark as Worn'),
                    ),
                  ),

                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build placeholder widget
  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.checkroom,
          size: 64,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  /// Build detail row
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Get color from color name
  Color _getColorFromString(String colorName) {
    final Map<String, Color> colorMap = {
      'Blue': Colors.blue,
      'White': Colors.grey.shade100,
      'Black': Colors.grey.shade900,
      'Khaki': const Color(0xFFF0E68C),
      'Brown': Colors.brown,
      'Red': Colors.red,
      'Green': Colors.green,
      'Yellow': Colors.yellow,
      'Purple': Colors.purple,
      'Pink': Colors.pink,
      'Orange': Colors.orange,
      'Grey': Colors.grey,
      'Beige': const Color(0xFFF5F5DC),
      'Navy': const Color(0xFF000080),
    };

    return colorMap[colorName] ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Closet'),
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(context, colorScheme),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AddClothingScreen()),
          );

          if (result == true) {
            _loadClothing();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build main body
  Widget _buildBody(BuildContext context, ColorScheme colorScheme) {
    if (_clothingList.isEmpty) {
      return _buildEmptyState(context, colorScheme);
    }

    // Summary counts
    final totalCount = _clothingService.getTotalCount();
    final availableCount = _clothingService.getAvailableCount();
    final laundryCount = _clothingService.getLaundryCount();

    return Column(
      children: [
        // Summary cards
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total',
                  totalCount.toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Available',
                  availableCount.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Laundry',
                  laundryCount.toString(),
                  Colors.orange,
                ),
              ),
            ],
          ),
        ),

        // Clothing grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _clothingList.length,
            itemBuilder: (context, index) {
              return _buildClothingCard(
                context,
                _clothingList[index],
                colorScheme,
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checkroom,
            size: 80,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 20),
          Text(
            'No Clothing Items',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first clothing item to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (context) => const AddClothingScreen()),
              );

              if (result == true) {
                _loadClothing();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Clothing'),
          ),
        ],
      ),
    );
  }

  /// Build summary card
  Widget _buildSummaryCard(
    BuildContext context,
    String label,
    String count,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
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

  /// Build clothing card
  Widget _buildClothingCard(
    BuildContext context,
    ClothingItem item,
    ColorScheme colorScheme,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showItemDetails(context, item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              child: Container(
                width: double.infinity,
                color: colorScheme.surfaceVariant,
                child: item.imagePath != null && item.imagePath!.isNotEmpty
                    ? Image.file(
                        File(item.imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.checkroom,
                              size: 48,
                              color: colorScheme.outline,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          Icons.checkroom,
                          size: 48,
                          color: colorScheme.outline,
                        ),
                      ),
              ),
            ),

            // Info section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            item.category,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontSize: 8,
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: _getColorFromString(item.color)
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            item.color,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 7,
                          color: _getStatusColor(item.status),
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'In Laundry':
        return Colors.orange;
      case 'Damaged':
        return Colors.red;
      case 'Archive':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}