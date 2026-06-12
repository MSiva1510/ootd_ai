import 'package:flutter/material.dart';
import 'package:ootd_ai/models/outfit.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/services/outfit_service.dart';

/// Screen for displaying and generating outfit recommendations
class OutfitScreen extends StatefulWidget {
  const OutfitScreen({super.key});

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  late OutfitService _outfitService;
  Outfit? _currentOutfit;
  Map<String, dynamic>? _outfitDetails;

  @override
  void initState() {
    super.initState();
    _outfitService = OutfitService();
    _currentOutfit = _outfitService.getTodaysOutfit();
    if (_currentOutfit != null) {
      _outfitDetails = _outfitService.getOutfitDetails(_currentOutfit);
    }
  }

  /// Generate a new outfit
  void _generateOutfit() {
    final outfit = _outfitService.generateTodaysOutfit();

    if (outfit == null) {
      // Not enough clothes available
      _showMissingClothesDialog();
    } else {
      setState(() {
        _currentOutfit = outfit;
        _outfitDetails = _outfitService.getOutfitDetails(outfit);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Outfit generated successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Show dialog when not enough clothes available
  void _showMissingClothesDialog() {
    final missing = _outfitService.getMissingCategories();
    final missingText = missing.join(', ');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Not Enough Clothes'),
          content: Text(
            'Unable to generate outfit. Missing: $missingText',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to closet to add more clothes
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Go to Closet'),
            ),
          ],
        );
      },
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
        title: const Text('Today\'s Outfit'),
        elevation: 0,
        centerTitle: false,
      ),
      body: _buildBody(context, colorScheme),
    );
  }

  /// Build main body
  Widget _buildBody(BuildContext context, ColorScheme colorScheme) {
    if (_currentOutfit == null || _outfitDetails == null) {
      return _buildEmptyState(context, colorScheme);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's outfit header
          Text(
            'Your Outfit for Today',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),

          // Outfit visualization
          _buildOutfitDisplay(context, colorScheme),

          const SizedBox(height: 24),

          // Top wear section
          _buildOutfitSection(
            context,
            colorScheme,
            '👕 Top Wear',
            _outfitDetails!['shirt'] as ClothingItem,
          ),

          const SizedBox(height: 16),

          // Bottom wear section
          _buildOutfitSection(
            context,
            colorScheme,
            '👖 Bottom Wear',
            _outfitDetails!['pant'] as ClothingItem,
          ),

          const SizedBox(height: 16),

          // Footwear section
          _buildOutfitSection(
            context,
            colorScheme,
            '👟 Footwear',
            _outfitDetails!['footwear'] as ClothingItem,
          ),

          const SizedBox(height: 32),

          // Generate outfit button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _generateOutfit,
              icon: const Icon(Icons.refresh),
              label: const Text('Generate New Outfit'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
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
            'No Outfit Generated',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate your first outfit for today',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _generateOutfit,
            icon: const Icon(Icons.add),
            label: const Text('Generate Outfit'),
          ),
        ],
      ),
    );
  }

/// Build outfit visualization with three colored sections
  Widget _buildOutfitDisplay(BuildContext context, ColorScheme colorScheme) {
    final shirt = _outfitDetails!['shirt'] as ClothingItem;
    final pant = _outfitDetails!['pant'] as ClothingItem;
    final footwear = _outfitDetails!['footwear'] as ClothingItem;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Top wear color
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _getColorFromString(shirt.color),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.checkroom,
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shirt.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Bottom wear color
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _getColorFromString(pant.color),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.checkroom,
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pant.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Footwear color
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _getColorFromString(footwear.color),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.checkroom,
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        footwear.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build outfit section card
  Widget _buildOutfitSection(
    BuildContext context,
    ColorScheme colorScheme,
    String title,
    ClothingItem item,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Color preview
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getColorFromString(item.color),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.category,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.color,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
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
            ),
          ],
        ),
      ),
    );
  }
}
