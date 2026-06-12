import 'dart:math';
import 'package:intl/intl.dart' as intl;
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/models/outfit.dart';
import 'package:ootd_ai/services/clothing_service.dart';

/// Service for managing outfit recommendations
class OutfitService {
  /// Singleton instance
  static final OutfitService _instance = OutfitService._internal();

  /// Reference to ClothingService
  late ClothingService _clothingService;

  /// Store today's outfit
  Outfit? _todaysOutfit;

  /// Random number generator for outfit selection
  late Random _random;

  /// History of generated/saved outfits (used for Dashboard & History screens)
  final List<Outfit> _outfits = [];

  /// Private constructor
  OutfitService._internal() {
    _clothingService = ClothingService();
    _random = Random();
  }

  /// Factory constructor to return singleton instance
  factory OutfitService() {
    return _instance;
  }

  /// Generate today's outfit from available clothes
  /// 
  /// Selects:
  /// - 1 Shirt or T-Shirt
  /// - 1 Pant or Jeans
  /// - 1 Footwear (Shoe, Sandal, Chappal)
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

    // Randomly select one from each category
    final selectedShirt = shirts[_random.nextInt(shirts.length)];
    final selectedPant = pants[_random.nextInt(pants.length)];
    final selectedFootwear = footwear[_random.nextInt(footwear.length)];

    // Create outfit
    final now = DateTime.now();
    final outfit = Outfit(
      id: now.millisecondsSinceEpoch.toString(),
      date: now,
      shirtId: selectedShirt.id,
      pantId: selectedPant.id,
      footwearId: selectedFootwear.id,
      title: 'Outfit - ${intl.DateFormat('MMM d, y - h:mm a').format(now)}',
      itemIds: [selectedShirt.id, selectedPant.id, selectedFootwear.id],
    );

    // Store as today's outfit
    _todaysOutfit = outfit;

    // Add to history
    _outfits.add(outfit);

    return outfit;
  }

  /// Get today's outfit
  /// 
  /// Returns the currently stored outfit for today.
  /// Returns null if no outfit has been generated.
  Outfit? getTodaysOutfit() {
    return _todaysOutfit;
  }

  /// Get clothing item by ID
  /// 
  /// Used to retrieve full details of items in an outfit
  ClothingItem? getClothingItemById(String id) {
    return _clothingService.getById(id);
  }

  /// Get outfit details with full clothing information
  /// 
  /// Returns a map with:
  /// - outfit: the Outfit object
  /// - shirt: the ClothingItem for shirt
  /// - pant: the ClothingItem for pant
  /// - footwear: the ClothingItem for footwear
  /// 
  /// Returns null if outfit is null or any item is not found
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
  /// 
  /// Returns true if there's at least:
  /// - 1 shirt/t-shirt available
  /// - 1 pant/jeans available
  /// - 1 footwear available
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
  /// 
  /// Returns a list of categories that are missing.
  /// Useful for providing feedback to user.
  /// 
  /// Example: ['Shirt', 'Footwear']
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

  // --- Added for Dashboard & History screens ---

  /// Get all outfits in history (most recently added last)
  List<Outfit> getAllOutfits() {
    return _outfits;
  }

  /// Get all outfits marked as favorite
  List<Outfit> getFavoriteOutfits() {
    return _outfits.where((outfit) => outfit.isFavorite).toList();
  }

  /// Toggle favorite status of an outfit by id
  void toggleFavorite(String id) {
    final index = _outfits.indexWhere((o) => o.id == id);
    if (index != -1) {
      _outfits[index] = _outfits[index].copyWith(
        isFavorite: !_outfits[index].isFavorite,
      );
      if (_todaysOutfit?.id == id) {
        _todaysOutfit = _outfits[index];
      }
    }
  }

  /// Rate an outfit by id (0-5)
  void rateOutfit(String id, int rating) {
    final index = _outfits.indexWhere((o) => o.id == id);
    if (index != -1) {
      _outfits[index] = _outfits[index].copyWith(ratings: rating);
      if (_todaysOutfit?.id == id) {
        _todaysOutfit = _outfits[index];
      }
    }
  }

  /// Add an outfit to history (e.g. for seeding/testing or manual saves)
  void addOutfit(Outfit outfit) {
    _outfits.add(outfit);
  }

  /// Clear all outfit history
  void clearAll() {
    _outfits.clear();
    _todaysOutfit = null;
  }
}