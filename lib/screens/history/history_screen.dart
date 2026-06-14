import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ootd_ai/models/outfit.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/services/outfit_service.dart';

/// Screen for displaying outfit history
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late OutfitService _outfitService;
  List<Outfit> _outfitHistory = [];

  @override
  void initState() {
    super.initState();
    _outfitService = OutfitService();
    _loadHistory();
  }

  /// Load outfit history from service
  void _loadHistory() {
    setState(() {
      _outfitHistory = _outfitService.getAllOutfits();
    });
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

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final outfitDate = DateTime(date.year, date.month, date.day);

    if (outfitDate == today) {
      return 'Today';
    } else if (outfitDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Show outfit details in bottom sheet
  void _showOutfitDetails(BuildContext context, Outfit outfit) {
    final details = _outfitService.getOutfitDetails(outfit);
    if (details == null) return;

    final shirt = details['shirt'] as ClothingItem;
    final pant = details['pant'] as ClothingItem;
    final footwear = details['footwear'] as ClothingItem;

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
                  'Outfit Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                _buildDetailRow(context, 'Date', _formatDate(outfit.date)),
                const SizedBox(height: 16),
                Text(
                  '👕 Top Wear',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                _buildItemDetail(context, shirt),
                const SizedBox(height: 16),
                Text(
                  '👖 Bottom Wear',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                _buildItemDetail(context, pant),
                const SizedBox(height: 16),
                Text(
                  '👟 Footwear',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                _buildItemDetail(context, footwear),
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
          ),
        );
      },
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
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Build item detail
  Widget _buildItemDetail(BuildContext context, ClothingItem item) {
    return Row(
      children: [
        if (item.imagePath != null && item.imagePath!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(item.imagePath!),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getColorFromString(item.color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          )
        else
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getColorFromString(item.color),
              borderRadius: BorderRadius.circular(8),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      item.category,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      item.color,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit History'),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_outfitHistory.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  '${_outfitHistory.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(context, colorScheme),
    );
  }

  /// Build main body
  Widget _buildBody(BuildContext context, ColorScheme colorScheme) {
    if (_outfitHistory.isEmpty) {
      return _buildEmptyState(context, colorScheme);
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadHistory();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _outfitHistory.length,
        itemBuilder: (context, index) {
          return _buildOutfitCard(
            context,
            _outfitHistory[index],
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
            Icons.history,
            size: 80,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 20),
          Text(
            'No Outfit History',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start generating outfits to see history',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/outfit');
            },
            icon: const Icon(Icons.checkroom),
            label: const Text('Go to Outfit'),
          ),
        ],
      ),
    );
  }

  /// Build outfit history card
  Widget _buildOutfitCard(
    BuildContext context,
    Outfit outfit,
    ColorScheme colorScheme,
  ) {
    final details = _outfitService.getOutfitDetails(outfit);
    if (details == null) return const SizedBox.shrink();

    final shirt = details['shirt'] as ClothingItem;
    final pant = details['pant'] as ClothingItem;
    final footwear = details['footwear'] as ClothingItem;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _showOutfitDetails(context, outfit),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              Text(
                _formatDate(outfit.date),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),

              // Color preview boxes
              Row(
                children: [
                  // Shirt color
                  Expanded(
                    child: _buildColorPreviewWithLabel(
                      context,
                      '👕',
                      shirt.color,
                      _getColorFromString(shirt.color),
                      shirt.name,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Pant color
                  Expanded(
                    child: _buildColorPreviewWithLabel(
                      context,
                      '👖',
                      pant.color,
                      _getColorFromString(pant.color),
                      pant.name,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Footwear color
                  Expanded(
                    child: _buildColorPreviewWithLabel(
                      context,
                      '👟',
                      footwear.color,
                      _getColorFromString(footwear.color),
                      footwear.name,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Item names
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      shirt.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      footwear.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Tap to view details
              Text(
                'Tap to view details',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 9,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build color preview with label
  Widget _buildColorPreviewWithLabel(
    BuildContext context,
    String emoji,
    String colorName,
    Color color,
    String itemName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          colorName,
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}