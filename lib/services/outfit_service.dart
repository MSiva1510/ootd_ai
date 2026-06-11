import 'package:ootd_ai/models/outfit.dart';

class OutfitService {
  static final OutfitService _instance = OutfitService._internal();

  final List<Outfit> _outfits = [];

  factory OutfitService() {
    return _instance;
  }

  OutfitService._internal();

  // Get all outfits
  List<Outfit> getAllOutfits() {
    return _outfits;
  }

  // Get favorite outfits
  List<Outfit> getFavoriteOutfits() {
    return _outfits.where((outfit) => outfit.isFavorite).toList();
  }

  // Get outfits by occasion
  List<Outfit> getOutfitsByOccasion(String occasion) {
    return _outfits.where((outfit) => outfit.occasion == occasion).toList();
  }

  // Get outfits by weather
  List<Outfit> getOutfitsByWeather(String weather) {
    return _outfits.where((outfit) => outfit.weatherSuitable == weather).toList();
  }

  // Add a new outfit
  Future<void> addOutfit(Outfit outfit) async {
    _outfits.add(outfit);
    // TODO: Persist to database
  }

  // Update outfit
  Future<void> updateOutfit(Outfit outfit) async {
    final index = _outfits.indexWhere((o) => o.id == outfit.id);
    if (index != -1) {
      _outfits[index] = outfit;
      // TODO: Persist to database
    }
  }

  // Delete outfit
  Future<void> deleteOutfit(String id) async {
    _outfits.removeWhere((outfit) => outfit.id == id);
    // TODO: Persist to database
  }

  // Rate outfit
  Future<void> rateOutfit(String id, int rating) async {
    final index = _outfits.indexWhere((o) => o.id == id);
    if (index != -1) {
      final outfit = _outfits[index];
      _outfits[index] = Outfit(
        id: outfit.id,
        title: outfit.title,
        description: outfit.description,
        itemIds: outfit.itemIds,
        createdAt: outfit.createdAt,
        ratings: rating,
        occasion: outfit.occasion,
        weatherSuitable: outfit.weatherSuitable,
        tags: outfit.tags,
        isFavorite: outfit.isFavorite,
      );
      // TODO: Persist to database
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String id) async {
    final index = _outfits.indexWhere((o) => o.id == id);
    if (index != -1) {
      final outfit = _outfits[index];
      _outfits[index] = Outfit(
        id: outfit.id,
        title: outfit.title,
        description: outfit.description,
        itemIds: outfit.itemIds,
        createdAt: outfit.createdAt,
        ratings: outfit.ratings,
        occasion: outfit.occasion,
        weatherSuitable: outfit.weatherSuitable,
        tags: outfit.tags,
        isFavorite: !outfit.isFavorite,
      );
      // TODO: Persist to database
    }
  }

  // Search outfits
  List<Outfit> searchOutfits(String query) {
    return _outfits
        .where((outfit) =>
            outfit.title.toLowerCase().contains(query.toLowerCase()) ||
            outfit.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  void clearAll() {
    _outfits.clear();
  }
}
