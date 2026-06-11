import 'package:flutter/material.dart';
import 'package:ootd_ai/services/clothing_service.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/screens/closet/add_clothing_screen.dart';

/// Closet screen for managing clothing items
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
    _loadClothingItems();
  }

  /// Load clothing items from service
  void _loadClothingItems() {
    setState(() {
      _clothingList = _clothingService.getAllClothes();
    });
  }

  /// Navigate to Add Clothing Screen
  void _onAddClothingPressed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddClothingScreen(),
      ),
    );

    // If item was added, refresh the list
    if (result == true) {
      _loadClothingItems();
    }
  }

  /// Get status color based on status string
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
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Closet'),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${_clothingList.length} items',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(context, colorScheme),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddClothingPressed,
        tooltip: 'Add Clothing',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build the main body of the screen
  Widget _buildBody(BuildContext context, ColorScheme colorScheme) {
    if (_clothingList.isEmpty) {
      return _buildEmptyState(context, colorScheme);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total Items',
                  _clothingList.length.toString(),
                  Icons.checkroom,
                  colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Available',
                  _clothingService.getAvailableCount().toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Clothing grid
          Text(
            'Your Wardrobe',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
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
          const SizedBox(height: 32),
        ],
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
            Icons.checkroom_outlined,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Your Closet is Empty',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first clothing item',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _onAddClothingPressed,
            icon: const Icon(Icons.add),
            label: const Text('Add Clothing'),
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual clothing card
  Widget _buildClothingCard(
    BuildContext context,
    ClothingItem item,
    ColorScheme colorScheme,
  ) {
    final statusColor = _getStatusColor(item.status);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _showClothingDetails(context, item);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder with color
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _getColorFromString(item.color),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getColorFromString(item.color),
                    _getColorFromString(item.color).withOpacity(0.7),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(item.category),
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),

            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Item details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.category,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                        ),
                      ],
                    ),

                    // Status badge
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.status,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show clothing item details
  void _showClothingDetails(BuildContext context, ClothingItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow(context, 'Name', item.name),
              _buildDetailRow(context, 'Category', item.category),
              _buildDetailRow(context, 'Color', item.color),
              _buildDetailRow(context, 'Status', item.status),
              _buildDetailRow(
                context,
                'Added',
                '${item.dateAdded.day}/${item.dateAdded.month}/${item.dateAdded.year}',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build detail row for bottom sheet
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Get color from color name string
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

  /// Get appropriate icon for category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Shirt':
      case 'T-Shirt':
      case 'Pant':
      case 'Jeans':
      case 'Shoe':
      case 'Sandal':
      case 'Chappal':
        return Icons.checkroom;
      default:
        return Icons.checkroom;
    }
  }
}