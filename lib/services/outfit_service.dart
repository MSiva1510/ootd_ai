import 'package:ootd_ai/models/outfit.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/services/clothing_service.dart';
import 'dart:math';

/// Service for managing outfit generation and history
class OutfitService {
  /// Singleton instance
  static final OutfitService _instance = OutfitService._internal();

  /// In-memory outfit history (newest first)
  List<Outfit> _outfitHistory = [];

  /// Reference to clothing service
  late ClothingService _clothingService;

  /// Private constructor
  OutfitService._internal() {
    _clothingService = ClothingService();
  }

  /// Factory constructor to return singleton instance
  factory OutfitService() {
    return _instance;
  }

  /// Get today's outfit
  Outfit? getTodaysOutfit() {
    final today = DateTime.now();
    try {
      return _outfitHistory.firstWhere((outfit) =>
          outfit.date.year == today.year &&
          outfit.date.month == today.month &&
          outfit.date.day == today.day);
    } catch (e) {
      return null;
    }
  }

  /// Generate today's outfit with anti-repetition and wear count tracking
  Outfit? generateTodaysOutfit() {
    final available = _clothingService.getAvailableClothes();

    // Get categories
    final shirts =
        available.where((item) => item.category == 'Shirt' || item.category == 'T-Shirt').toList();
    final pants = available
        .where((item) => item.category == 'Pant' || item.category == 'Jeans')
        .toList();
    final footwear = available
        .where((item) =>
            item.category == 'Shoe' ||
            item.category == 'Sandal' ||
            item.category == 'Chappal')
        .toList();

    // Check if enough items available
    if (shirts.isEmpty || pants.isEmpty || footwear.isEmpty) {
      return null;
    }

    // Get last outfit for anti-repetition
    final lastOutfit =
        _outfitHistory.isNotEmpty ? _outfitHistory.first : null;
    final lastOutfitDetails = lastOutfit != null
        ? getOutfitDetails(lastOutfit)
        : null;

    // Get previous IDs to avoid
    final lastShirtId = lastOutfitDetails?['shirt']?.id;
    final lastPantId = lastOutfitDetails?['pant']?.id;
    final lastFootwearId = lastOutfitDetails?['footwear']?.id;

    // Try to pick different items from last outfit
    ClothingItem? selectedShirt;
    if (lastShirtId != null) {
      final alternatives = shirts
          .where((item) => item.id != lastShirtId)
          .toList();
      selectedShirt = alternatives.isNotEmpty
          ? alternatives[Random().nextInt(alternatives.length)]
          : shirts[Random().nextInt(shirts.length)];
    } else {
      selectedShirt = shirts[Random().nextInt(shirts.length)];
    }

    ClothingItem? selectedPant;
    if (lastPantId != null) {
      final alternatives = pants
          .where((item) => item.id != lastPantId)
          .toList();
      selectedPant = alternatives.isNotEmpty
          ? alternatives[Random().nextInt(alternatives.length)]
          : pants[Random().nextInt(pants.length)];
    } else {
      selectedPant = pants[Random().nextInt(pants.length)];
    }

    ClothingItem? selectedFootwear;
    if (lastFootwearId != null) {
      final alternatives = footwear
          .where((item) => item.id != lastFootwearId)
          .toList();
      selectedFootwear = alternatives.isNotEmpty
          ? alternatives[Random().nextInt(alternatives.length)]
          : footwear[Random().nextInt(footwear.length)];
    } else {
      selectedFootwear = footwear[Random().nextInt(footwear.length)];
    }

    // Create outfit
    final outfit = Outfit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      shirtId: selectedShirt!.id,
      pantId: selectedPant!.id,
      footwearId: selectedFootwear!.id,
    );

    // Increment wear count for selected items
    _clothingService.incrementWearCount(selectedShirt.id);
    _clothingService.incrementWearCount(selectedPant.id);
    _clothingService.incrementWearCount(selectedFootwear.id);

    // Remove old today's outfit if it exists
    _outfitHistory.removeWhere((o) {
      final now = DateTime.now();
      return o.date.year == now.year &&
          o.date.month == now.month &&
          o.date.day == now.day &&
          o.id != outfit.id;
    });

    // Add to history (newest first)
    _outfitHistory.insert(0, outfit);

    return outfit;
  }

  /// Get all outfits in history
  List<Outfit> getAllOutfits() {
    return List.from(_outfitHistory);
  }

  /// Get favorite outfits (first 5)
  List<Outfit> getFavoriteOutfits() {
    return _outfitHistory.take(5).toList();
  }

  /// Get previous outfit (second in history)
  Outfit? getPreviousOutfit() {
    if (_outfitHistory.length < 2) {
      return null;
    }
    return _outfitHistory[1];
  }

  /// Get outfits from last N days
  List<Outfit> getOutfitHistoryForDays(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _outfitHistory
        .where((outfit) => outfit.date.isAfter(cutoffDate))
        .toList();
  }

  /// Get outfit details with clothing items
  Map<String, dynamic>? getOutfitDetails(Outfit outfit) {
    final shirt = _clothingService.getById(outfit.shirtId);
    final pant = _clothingService.getById(outfit.pantId);
    final footwear = _clothingService.getById(outfit.footwearId);

    if (shirt == null || pant == null || footwear == null) {
      return null;
    }

    return {
      'shirt': shirt,
      'pant': pant,
      'footwear': footwear,
    };
  }

  /// Get missing categories for outfit generation
  List<String> getMissingCategories() {
    final available = _clothingService.getAvailableClothes();

    final hasShirt = available.any((item) =>
        item.category == 'Shirt' || item.category == 'T-Shirt');
    final hasPant = available.any((item) =>
        item.category == 'Pant' || item.category == 'Jeans');
    final hasFootwear = available.any((item) =>
        item.category == 'Shoe' ||
        item.category == 'Sandal' ||
        item.category == 'Chappal');

    final missing = <String>[];
    if (!hasShirt) missing.add('Shirt');
    if (!hasPant) missing.add('Pant');
    if (!hasFootwear) missing.add('Footwear');

    return missing;
  }

  /// Check if outfit can be generated
  bool canGenerateOutfit() {
    return getMissingCategories().isEmpty;
  }

  /// Get total number of outfits generated
  int getHistoryCount() {
    return _outfitHistory.length;
  }

  /// Get laundry completion count
  int getLaundryCompletionCount() {
    // Count items that are currently in laundry
    // This would require tracking completed laundry cycles
    // For now, return number of items ever put in laundry
    final allItems = _clothingService.getAllClothes();
    return allItems.where((item) => item.laundryStart != null).length;
  }

  /// Clear all outfit history
  Future<void> clearHistory() async {
    _outfitHistory.clear();
  }

  /// Reload outfit history
  Future<void> reload() async {
    // In-memory service, nothing to reload
  }
}