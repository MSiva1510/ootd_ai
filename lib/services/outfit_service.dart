import 'dart:math';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/models/outfit.dart';
import 'package:ootd_ai/services/clothing_service.dart';

/// Service for managing outfit recommendations with smart history
class OutfitService {
  /// Singleton instance
  static final OutfitService _instance = OutfitService._internal();

  /// Reference to ClothingService
  late ClothingService _clothingService;

  /// Store today's outfit
  Outfit? _todaysOutfit;

  /// Store outfit history (in-memory only)
  final List<Outfit> _outfitHistory = [];

  /// Random number generator for outfit selection
  late Random _random;

  /// Private constructor
  OutfitService._internal() {
    _clothingService = ClothingService();
    _random = Random();
  }

  /// Factory constructor to return singleton instance
  factory OutfitService() {
    return _instance;
  }

  /// Generate today's outfit from available clothes with anti-repetition logic
  /// 
  /// Selects:
  /// - 1 Shirt or T-Shirt (avoiding previous outfit if possible)
  /// - 1 Pant or Jeans (avoiding previous outfit if possible)
  /// - 1 Footwear (Shoe, Sandal, Chappal) (avoiding previous outfit if possible)
  /// 
  /// Only uses clothes with status = "Available"
  /// Returns null if not enough clothes available
  Outfit? generateTodaysOutfit() {
    // Get all available clothes
    final availableClothes = _clothingService.getAvailableClothes();

    // Get clothes by category
    final shirts = availableClothes
        .where((item) => item.category == 'Shirt' || item.category == 'T-Shirt')
        .toList();

    final pants = availableClothes
        .where((item) => item.category == 'Pant' || item.category == 'Jeans')
        .toList();

    final footwear = availableClothes
        .where((item) =>
            item.category == 'Shoe' ||
            item.category == 'Sandal' ||
            item.category == 'Chappal')
        .toList();

    // Check if we have enough clothes
    if (shirts.isEmpty || pants.isEmpty || footwear.isEmpty) {
      return null;
    }

    // Get previous outfit items to avoid repetition
    String? previousShirtId;
    String? previousPantId;
    String? previousFootwearId;

    if (_outfitHistory.isNotEmpty) {
      final previousOutfit = _outfitHistory.first;
      previousShirtId = previousOutfit.shirtId;
      previousPantId = previousOutfit.pantId;
      previousFootwearId = previousOutfit.footwearId;
    }

    // Try to avoid previous items, but fall back if necessary
    var availableShirts = shirts
        .where((item) => item.id != previousShirtId)
        .toList();
    if (availableShirts.isEmpty) {
      availableShirts = shirts; // Use all if none available without previous
    }

    var availablePants = pants
        .where((item) => item.id != previousPantId)
        .toList();
    if (availablePants.isEmpty) {
      availablePants = pants; // Use all if none available without previous
    }

    var availableFootwear = footwear
        .where((item) => item.id != previousFootwearId)
        .toList();
    if (availableFootwear.isEmpty) {
      availableFootwear = footwear; // Use all if none available without previous
    }

    // Randomly select one from each category
    final selectedShirt = availableShirts[_random.nextInt(availableShirts.length)];
    final selectedPant = availablePants[_random.nextInt(availablePants.length)];
    final selectedFootwear = availableFootwear[_random.nextInt(availableFootwear.length)];

    // Create outfit
    final outfit = Outfit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      shirtId: selectedShirt.id,
      pantId: selectedPant.id,
      footwearId: selectedFootwear.id,
    );

    // Store as today's outfit
    _todaysOutfit = outfit;

    // Add to history (newest first)
    _outfitHistory.insert(0, outfit);

    return outfit;
  }

  /// Get today's outfit
  Outfit? getTodaysOutfit() {
    return _todaysOutfit;
  }

  /// Get all outfit history (newest first)
  List<Outfit> getAllOutfits() {
    return List.from(_outfitHistory);
  }

  /// Get favorite outfits (most recent first, limited to 5)
  List<Outfit> getFavoriteOutfits() {
    return _outfitHistory.take(5).toList();
  }

  /// Get outfit history for a specific number of days
  List<Outfit> getOutfitHistoryForDays(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _outfitHistory
        .where((outfit) => outfit.date.isAfter(cutoffDate))
        .toList();
  }

  /// Get clothing item by ID
  ClothingItem? getClothingItemById(String id) {
    return _clothingService.getById(id);
  }

  /// Get outfit details with full clothing information
  Map<String, dynamic>? getOutfitDetails(Outfit? outfit) {
    if (outfit == null) return null;

    final shirt = _clothingService.getById(outfit.shirtId);
    final pant = _clothingService.getById(outfit.pantId);
    final footwear = _clothingService.getById(outfit.footwearId);

    // If any item is not found, return null
    if (shirt == null || pant == null || footwear == null) {
      return null;
    }

    return {
      'outfit': outfit,
      'shirt': shirt,
      'pant': pant,
      'footwear': footwear,
    };
  }

  /// Check if there are enough clothes to generate an outfit
  bool canGenerateOutfit() {
    final availableClothes = _clothingService.getAvailableClothes();

    final hasShirt = availableClothes.any(
      (item) => item.category == 'Shirt' || item.category == 'T-Shirt',
    );

    final hasPant = availableClothes.any(
      (item) => item.category == 'Pant' || item.category == 'Jeans',
    );

    final hasFootwear = availableClothes.any(
      (item) =>
          item.category == 'Shoe' ||
          item.category == 'Sandal' ||
          item.category == 'Chappal',
    );

    return hasShirt && hasPant && hasFootwear;
  }

  /// Get missing clothing categories
  List<String> getMissingCategories() {
    final availableClothes = _clothingService.getAvailableClothes();
    final missing = <String>[];

    final hasShirt = availableClothes.any(
      (item) => item.category == 'Shirt' || item.category == 'T-Shirt',
    );
    if (!hasShirt) missing.add('Shirt');

    final hasPant = availableClothes.any(
      (item) => item.category == 'Pant' || item.category == 'Jeans',
    );
    if (!hasPant) missing.add('Pant');

    final hasFootwear = availableClothes.any(
      (item) =>
          item.category == 'Shoe' ||
          item.category == 'Sandal' ||
          item.category == 'Chappal',
    );
    if (!hasFootwear) missing.add('Footwear');

    return missing;
  }

  /// Clear today's outfit
  void clearTodaysOutfit() {
    _todaysOutfit = null;
  }

  /// Get history count
  int getHistoryCount() {
    return _outfitHistory.length;
  }

  /// Get previous outfit (one before today's)
  Outfit? getPreviousOutfit() {
    if (_outfitHistory.isEmpty) return null;
    if (_outfitHistory.length == 1) return null;
    return _outfitHistory[1];
  }
}