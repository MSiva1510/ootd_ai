import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ootd_ai/models/outfit.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/services/outfit_service.dart';

/// Screen for displaying and generating outfit recommendations
class OutfitScreen extends StatefulWidget {
  const OutfitScreen({Key? key}) : super(key: key);

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
                Navigator.pushNamed(context, '/closet');
              },
              child: const Text('Go to Closet'),
            ),
          ],
        );
      },
    );
  }

  /// Format time for display
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Outfit'),
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(context, colorScheme),
    );
  }

  /// Build main body
  Widget _buildBody(BuildContext context, ColorScheme colorScheme) {
    if (_currentOutfit == null || _outfitDetails == null) {
      return _buildEmptyState(context, colorScheme);
    }

    final previousOutfit = _outfitService.getPreviousOutfit();
    final previousDetails = previousOutfit != null
        ? _outfitService.getOutfitDetails(previousOutfit)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with generation time
          _buildHeaderSection(context, colorScheme),

          const SizedBox(height: 24),

          // Top wear section
          _buildOutfitItemCard(
            context,
            colorScheme,
            '👕 Top Wear',
            _outfitDetails!['shirt'] as ClothingItem,
          ),

          const SizedBox(height: 16),

          // Bottom wear section
          _buildOutfitItemCard(
            context,
            colorScheme,
            '👖 Bottom Wear',
            _outfitDetails!['pant'] as ClothingItem,
          ),

          const SizedBox(height: 16),

          // Footwear section
          _buildOutfitItemCard(
            context,
            colorScheme,
            '👟 Footwear',
            _outfitDetails!['footwear'] as ClothingItem,
          ),

          const SizedBox(height: 32),

          // Previous outfit summary (if available)
          if (previousDetails != null)
            _buildPreviousOutfitSummary(context, colorScheme, previousDetails),

          if (previousDetails != null) const SizedBox(height: 32),

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

  /// Build header section with generation time
  Widget _buildHeaderSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Outfit for Today',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: colorScheme.outline,
            ),
            const SizedBox(width: 8),
            Text(
              'Generated: ${_formatTime(_currentOutfit!.date)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),
          ],
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

  /// Build outfit item card with image
  Widget _buildOutfitItemCard(
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

            // Image or placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 200,
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
                              size: 64,
                              color: colorScheme.outline,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          Icons.checkroom,
                          size: 64,
                          color: colorScheme.outline,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Item details
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
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
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
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.color,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
    );
  }

  /// Build previous outfit summary
  Widget _buildPreviousOutfitSummary(
    BuildContext context,
    ColorScheme colorScheme,
    Map<String, dynamic> previousDetails,
  ) {
    final previousShirt = previousDetails['shirt'] as ClothingItem;
    final previousPant = previousDetails['pant'] as ClothingItem;
    final previousFootwear = previousDetails['footwear'] as ClothingItem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Previous Outfit',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generated earlier',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Shirt preview
                    Expanded(
                      child: _buildSmallOutfitPreview(
                        context,
                        colorScheme,
                        '👕',
                        previousShirt,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Pant preview
                    Expanded(
                      child: _buildSmallOutfitPreview(
                        context,
                        colorScheme,
                        '👖',
                        previousPant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Footwear preview
                    Expanded(
                      child: _buildSmallOutfitPreview(
                        context,
                        colorScheme,
                        '👟',
                        previousFootwear,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build small outfit preview
  Widget _buildSmallOutfitPreview(
    BuildContext context,
    ColorScheme colorScheme,
    String emoji,
    ClothingItem item,
  ) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 80,
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
                          size: 32,
                          color: colorScheme.outline,
                        ),
                      );
                    },
                  )
                : Center(
                    child: Icon(
                      Icons.checkroom,
                      size: 32,
                      color: colorScheme.outline,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.name,
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}