import 'package:ootd_ai/models/clothing_item.dart';

class ClothingService {
  // In a real app, this would use a database or API
  static final ClothingService _instance = ClothingService._internal();

  final List<ClothingItem> _items = [];

  factory ClothingService() {
    return _instance;
  }

  ClothingService._internal();

  // Get all clothing items
  List<ClothingItem> getAllItems() {
    return _items;
  }

  // Get items by category
  List<ClothingItem> getItemsByCategory(String category) {
    return _items.where((item) => item.category == category).toList();
  }

  // Add a new clothing item
  Future<void> addItem(ClothingItem item) async {
    _items.add(item);
    // TODO: Persist to database
  }

  // Update a clothing item
  Future<void> updateItem(ClothingItem item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      // TODO: Persist to database
    }
  }

  // Delete a clothing item
  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    // TODO: Persist to database
  }

  // Search items
  List<ClothingItem> searchItems(String query) {
    return _items
        .where((item) =>
            item.name.toLowerCase().contains(query.toLowerCase()) ||
            item.color.toLowerCase().contains(query.toLowerCase()) ||
            item.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  // Get statistics
  Map<String, int> getCategoryStats() {
    final Map<String, int> stats = {};
    for (var item in _items) {
      stats[item.category] = (stats[item.category] ?? 0) + 1;
    }
    return stats;
  }

  // Clear all items (for testing)
  void clearAll() {
    _items.clear();
  }
}
