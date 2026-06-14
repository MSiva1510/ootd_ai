import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/screens/closet/add_clothing_screen.dart';
import 'package:ootd_ai/services/clothing_service.dart';

/// Smart closet screen with search, filters, and sorting
class ClosetScreen extends StatefulWidget {
  const ClosetScreen({Key? key}) : super(key: key);

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  late ClothingService _clothingService;
  List<ClothingItem> _displayedClothes = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';
  String _selectedColor = 'All';
  String _sortBy = 'Newest First';

  final List<String> _categories = [
    'All',
    'Shirt',
    'T-Shirt',
    'Pant',
    'Jeans',
    'Shoe',
    'Sandal',
    'Chappal'
  ];

  final List<String> _statuses = ['All', 'Available', 'In Laundry', 'Damaged', 'Archive'];

  final List<String> _colors = [
    'All',
    'Black',
    'White',
    'Blue',
    'Red',
    'Green',
    'Brown',
    'Khaki'
  ];

  final List<String> _sortOptions = [
    'Newest First',
    'Oldest First',
    'Name A-Z',
    'Name Z-A',
    'Category',
    'Color'
  ];

  @override
  void initState() {
    super.initState();
    _clothingService = ClothingService();
    _loadAndFilter();
  }

  /// Load and apply filters
  void _loadAndFilter() {
    var clothes = _clothingService.getAllClothes();

    // Apply search
    if (_searchQuery.isNotEmpty) {
      clothes = _clothingService.search(_searchQuery);
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      clothes = clothes
          .where((item) => item.category == _selectedCategory)
          .toList();
    }

    // Apply status filter
    if (_selectedStatus != 'All') {
      clothes = clothes
          .where((item) => item.status == _selectedStatus)
          .toList();
    }

    // Apply color filter
    if (_selectedColor != 'All') {
      clothes = clothes
          .where((item) => item.color.toLowerCase() == _selectedColor.toLowerCase())
          .toList();
    }

    // Apply sorting
    _applySort(clothes);

    setState(() {
      _displayedClothes = clothes;
    });
  }

  /// Apply sorting to clothes list
  void _applySort(List<ClothingItem> clothes) {
    switch (_sortBy) {
      case 'Newest First':
        clothes.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        break;
      case 'Oldest First':
        clothes.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
        break;
      case 'Name A-Z':
        clothes.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name Z-A':
        clothes.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Category':
        clothes.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'Color':
        clothes.sort((a, b) => a.color.compareTo(b.color));
        break;
    }
  }

  /// Clear all filters
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
      _selectedStatus = 'All';
      _selectedColor = 'All';
      _sortBy = 'Newest First';
    });
    _loadAndFilter();
  }

  /// Mark item as worn
  void _markAsWorn(ClothingItem item) {
    _clothingService.markAsWorn(item.id);
    _loadAndFilter();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} moved to laundry'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Mark item as available
  void _markAsAvailable(ClothingItem item) {
    _clothingService.markAsAvailable(item.id);
    _loadAndFilter();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} is available'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Delete item
  void _deleteItem(ClothingItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Delete ${item.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                _clothingService.deleteClothingItem(item.id);
                Navigator.pop(context);
                _loadAndFilter();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} deleted'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// Show quick actions menu
  void _showQuickActions(BuildContext context, ClothingItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              if (item.status == 'Available')
                ListTile(
                  leading: const Icon(Icons.local_laundry_service),
                  title: const Text('Move to Laundry'),
                  onTap: () {
                    Navigator.pop(context);
                    _markAsWorn(item);
                  },
                ),
              if (item.status == 'In Laundry')
                ListTile(
                  leading: const Icon(Icons.done),
                  title: const Text('Mark as Available'),
                  onTap: () {
                    Navigator.pop(context);
                    _markAsAvailable(item);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteItem(item);
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show item details
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
                const SizedBox(height: 12),
                _buildDetailRow(context, 'Wear Count', '${item.wearCount}x'),
                if (item.status == 'In Laundry' && item.laundryUntil != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    'Ready by',
                    '${item.laundryUntil!.day}/${item.laundryUntil!.month}/${item.laundryUntil!.year}',
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showQuickActions(context, item);
                    },
                    child: const Text('Quick Actions'),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Closet'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              hintText: 'Search by name, color, category...',
              onChanged: (value) {
                setState(() => _searchQuery = value);
                _loadAndFilter();
              },
              leading: const Icon(Icons.search),
              trailing: _searchQuery.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                          _loadAndFilter();
                        },
                      )
                    ]
                  : [],
            ),
          ),

          // Filter and sort chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category filter
                Wrap(
                  spacing: 6,
                  children: _categories
                      .map(
                        (category) => FilterChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() => _selectedCategory = category);
                            _loadAndFilter();
                          },
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 8),

                // Status filter
                Wrap(
                  spacing: 6,
                  children: _statuses
                      .map(
                        (status) => FilterChip(
                          label: Text(status),
                          selected: _selectedStatus == status,
                          onSelected: (selected) {
                            setState(() => _selectedStatus = status);
                            _loadAndFilter();
                          },
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 8),

                // Color filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 6,
                    children: _colors
                        .map(
                          (color) => FilterChip(
                            label: Text(color),
                            selected: _selectedColor == color,
                            onSelected: (selected) {
                              setState(() => _selectedColor = color);
                              _loadAndFilter();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 12),

                // Sort and clear buttons
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isExpanded: true,
                        items: _sortOptions
                            .map((option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sortBy = value);
                            _loadAndFilter();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_searchQuery.isNotEmpty ||
                        _selectedCategory != 'All' ||
                        _selectedStatus != 'All' ||
                        _selectedColor != 'All')
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Clear'),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Clothing grid or empty state
          Expanded(
            child: _displayedClothes.isEmpty
                ? _buildEmptyState(context, colorScheme)
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _displayedClothes.length,
                    itemBuilder: (context, index) {
                      return _buildClothingCard(
                        context,
                        _displayedClothes[index],
                        colorScheme,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AddClothingScreen()),
          );

          if (result == true) {
            _loadAndFilter();
          }
        },
        child: const Icon(Icons.add),
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
            Icons.checkroom,
            size: 80,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 20),
          Text(
            'No Clothing Items Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _displayedClothes.isEmpty && _searchQuery.isEmpty
                ? 'Add your first clothing item to get started'
                : 'Try adjusting your filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (_searchQuery.isNotEmpty ||
              _selectedCategory != 'All' ||
              _selectedStatus != 'All' ||
              _selectedColor != 'All')
            FilledButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear),
              label: const Text('Clear Filters'),
            )
          else
            FilledButton.icon(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddClothingScreen()),
                );

                if (result == true) {
                  _loadAndFilter();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Clothing'),
            ),
        ],
      ),
    );
  }

  /// Build clothing card
  Widget _buildClothingCard(
    BuildContext context,
    ClothingItem item,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () => _showItemDetails(context, item),
      onLongPress: () => _showQuickActions(context, item),
      child: Card(
        clipBehavior: Clip.antiAlias,
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
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            item.category,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontSize: 8,
                                  color: Theme.of(context).colorScheme.primary,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.status,
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontSize: 7,
                                  color: _getStatusColor(item.status),
                                  fontWeight: FontWeight.w500,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item.wearCount}x',
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}