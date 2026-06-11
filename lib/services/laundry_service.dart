import 'package:ootd_ai/models/laundry_item.dart';

class LaundryService {
  static final LaundryService _instance = LaundryService._internal();

  final List<LaundryItem> _items = [];

  factory LaundryService() {
    return _instance;
  }

  LaundryService._internal();

  // Get all laundry items
  List<LaundryItem> getAllItems() {
    return _items;
  }

  // Get pending items
  List<LaundryItem> getPendingItems() {
    return _items.where((item) => item.status == LaundryStatus.pending).toList();
  }

  // Get in-progress items
  List<LaundryItem> getInProgressItems() {
    return _items
        .where((item) => item.status == LaundryStatus.inProgress)
        .toList();
  }

  // Get completed items
  List<LaundryItem> getCompletedItems() {
    return _items.where((item) => item.status == LaundryStatus.completed).toList();
  }

  // Add laundry item
  Future<void> addItem(LaundryItem item) async {
    _items.add(item);
    // TODO: Persist to database
  }

  // Update item status
  Future<void> updateStatus(String id, LaundryStatus status) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _items[index];
      _items[index] = LaundryItem(
        id: item.id,
        clothingItemId: item.clothingItemId,
        clothingItemName: item.clothingItemName,
        status: status,
        dateAdded: item.dateAdded,
        completionDate:
            status == LaundryStatus.completed ? DateTime.now() : null,
        notes: item.notes,
        washType: item.washType,
      );
      // TODO: Persist to database
    }
  }

  // Delete laundry item
  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    // TODO: Persist to database
  }

  // Get stats
  Map<String, int> getStats() {
    return {
      'pending': getPendingItems().length,
      'inProgress': getInProgressItems().length,
      'completed': getCompletedItems().length,
    };
  }

  void clearAll() {
    _items.clear();
  }
}
