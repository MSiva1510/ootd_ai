import 'package:ootd_ai/models/clothing_item.dart';

/// Service for managing clothing items with wear count and laundry intelligence
class ClothingService {
  /// Singleton instance
  static final ClothingService _instance = ClothingService._internal();

  /// In-memory list of clothing items (for performance)
  final List<ClothingItem> _clothingList = [];

  /// Private constructor
  ClothingService._internal();

  /// Factory constructor to return singleton instance
  factory ClothingService() {
    return _instance;
  }

  /// Get all clothing items
  List<ClothingItem> getAllClothes() {
    checkLaundryStatus();
    return List.from(_clothingList);
  }

  /// Get available clothing items (status = "Available")
  List<ClothingItem> getAvailableClothes() {
    checkLaundryStatus();
    return _clothingList
        .where((item) => item.status == 'Available')
        .toList();
  }

  /// Get clothing items in laundry (status = "In Laundry")
  List<ClothingItem> getLaundryClothes() {
    checkLaundryStatus();
    return _clothingList
        .where((item) => item.status == 'In Laundry')
        .toList();
  }

  /// Get clothing items by category
  List<ClothingItem> getByCategory(String category) {
    return _clothingList
        .where((item) => item.category == category)
        .toList();
  }

  /// Get clothing items by status
  List<ClothingItem> getByStatus(String status) {
    return _clothingList
        .where((item) => item.status == status)
        .toList();
  }

  /// Get clothing items by color
  List<ClothingItem> getByColor(String color) {
    return _clothingList
        .where((item) => item.color.toLowerCase() == color.toLowerCase())
        .toList();
  }

  /// Search clothing items
  List<ClothingItem> search(String query) {
    final lowerQuery = query.toLowerCase();
    return _clothingList
        .where((item) =>
            item.name.toLowerCase().contains(lowerQuery) ||
            item.category.toLowerCase().contains(lowerQuery) ||
            item.color.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get clothing item by ID
  ClothingItem? getById(String id) {
    try {
      return _clothingList.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new clothing item
  bool addClothing(String name, String category, String color) {
    final item = ClothingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      color: color,
      status: 'Available',
      dateAdded: DateTime.now(),
    );
    return addClothingItem(item);
  }

  /// Add a clothing item
  bool addClothingItem(ClothingItem item) {
    try {
      _clothingList.add(item);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update a clothing item
  bool updateClothingItem(ClothingItem item) {
    try {
      final index = _clothingList.indexWhere((cloth) => cloth.id == item.id);
      if (index != -1) {
        _clothingList[index] = item;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Delete a clothing item
  bool deleteClothingItem(String id) {
    try {
      final index = _clothingList.indexWhere((cloth) => cloth.id == id);
      if (index != -1) {
        _clothingList.removeAt(index);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Increment wear count for an item (called when outfit is generated)
  bool incrementWearCount(String id) {
    final item = getById(id);
    if (item == null) return false;

    final updated = item.copyWith(wearCount: item.wearCount + 1);
    return updateClothingItem(updated);
  }

  /// Mark item as worn (move to laundry for 24 hours with auto-return)
  bool markAsWorn(String id) {
    final item = getById(id);
    if (item == null) return false;

    final now = DateTime.now();
    final updatedItem = item.copyWith(
      status: 'In Laundry',
      laundryStart: now,
      laundryUntil: now.add(const Duration(hours: 24)),
    );

    return updateClothingItem(updatedItem);
  }

  /// Mark item as available (laundry done)
  bool markAsAvailable(String id) {
    final item = getById(id);
    if (item == null) return false;

    final updatedItem = item.copyWith(
      status: 'Available',
      laundryUntil: null,
      laundryStart: null,
    );

    return updateClothingItem(updatedItem);
  }

  /// Check laundry status and auto-return items after 24 hours
  void checkLaundryStatus() {
    final now = DateTime.now();

    for (int i = 0; i < _clothingList.length; i++) {
      final item = _clothingList[i];

      // Auto-return after 24 hours
      if (item.status == 'In Laundry' &&
          item.laundryStart != null &&
          now.difference(item.laundryStart!).inHours >= 24) {
        _clothingList[i] = item.copyWith(
          status: 'Available',
          laundryUntil: null,
          laundryStart: null,
        );
      }
    }
  }

  /// Get remaining laundry hours for an item
  int getRemainingLaundryHours(String id) {
    final item = getById(id);
    if (item == null || item.laundryStart == null) {
      return 0;
    }

    final now = DateTime.now();
    final elapsedHours = now.difference(item.laundryStart!).inHours;
    final remainingHours = 24 - elapsedHours;

    return remainingHours > 0 ? remainingHours : 0;
  }

  /// Get remaining laundry days for an item (for display purposes)
  int getRemainingLaundryDays(String id) {
    final hours = getRemainingLaundryHours(id);
    return (hours / 24).ceil();
  }

  /// Get total count of clothing items
  int getTotalCount() {
    return _clothingList.length;
  }

  /// Get count of available items
  int getAvailableCount() {
    return getAvailableClothes().length;
  }

  /// Get count of laundry items
  int getLaundryCount() {
    return getLaundryClothes().length;
  }

  /// Get count by category
  int getCategoryCount(String category) {
    return getByCategory(category).length;
  }

  /// Get most worn item
  ClothingItem? getMostWornItem() {
    if (_clothingList.isEmpty) return null;
    return _clothingList.reduce((a, b) =>
        a.wearCount > b.wearCount ? a : b);
  }

  /// Get least worn item
  ClothingItem? getLeastWornItem() {
    if (_clothingList.isEmpty) return null;
    return _clothingList.reduce((a, b) =>
        a.wearCount < b.wearCount ? a : b);
  }

  /// Get total wear count across all items
  int getTotalWearCount() {
    return _clothingList.fold(0, (sum, item) => sum + item.wearCount);
  }

  /// Clear all clothing items
  Future<void> clearAll() async {
    _clothingList.clear();
  }

  /// Reload clothing items
  Future<void> reload() async {
    // In-memory service, nothing to reload
  }
}