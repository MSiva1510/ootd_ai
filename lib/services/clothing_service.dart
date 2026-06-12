import 'package:ootd_ai/models/clothing_item.dart';

/// Service for managing clothing items in the wardrobe
class ClothingService {
  /// Singleton instance
  static final ClothingService _instance = ClothingService._internal();

  /// Private list to store clothing items
  late List<ClothingItem> _clothingList;

  /// Private constructor
  ClothingService._internal() {
    _initializeDummyData();
  }

  /// Factory constructor to return singleton instance
  factory ClothingService() {
    return _instance;
  }

  /// Initialize dummy clothing data
  void _initializeDummyData() {
    _clothingList = [
      ClothingItem(
        id: '1',
        name: 'Blue Formal Shirt',
        category: 'Shirt',
        color: 'Blue',
        status: 'Available',
        dateAdded: DateTime.now().subtract(const Duration(days: 30)),
      ),
      ClothingItem(
        id: '2',
        name: 'White T-Shirt',
        category: 'T-Shirt',
        color: 'White',
        status: 'Available',
        dateAdded: DateTime.now().subtract(const Duration(days: 15)),
      ),
      ClothingItem(
        id: '3',
        name: 'Black Jeans',
        category: 'Jeans',
        color: 'Black',
        status: 'In Laundry',
        dateAdded: DateTime.now().subtract(const Duration(days: 45)),
        laundryUntil: DateTime.now().add(const Duration(days: 1)),
      ),
      ClothingItem(
        id: '4',
        name: 'Khaki Pant',
        category: 'Pant',
        color: 'Khaki',
        status: 'Available',
        dateAdded: DateTime.now().subtract(const Duration(days: 20)),
      ),
      ClothingItem(
        id: '5',
        name: 'White Sneakers',
        category: 'Shoe',
        color: 'White',
        status: 'Available',
        dateAdded: DateTime.now().subtract(const Duration(days: 60)),
      ),
      ClothingItem(
        id: '6',
        name: 'Brown Sandals',
        category: 'Sandal',
        color: 'Brown',
        status: 'Available',
        dateAdded: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  /// Get all clothing items
  List<ClothingItem> getAllClothes() {
    // Check laundry status before returning
    checkLaundryStatus();
    return List.from(_clothingList);
  }

  /// Get only available clothing items
  List<ClothingItem> getAvailableClothes() {
    checkLaundryStatus();
    return _clothingList
        .where((item) => item.status == 'Available')
        .toList();
  }

  /// Get only laundry clothing items
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

  /// Get clothing item by id
  ClothingItem? getById(String id) {
    try {
      return _clothingList.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new clothing item
  /// 
  /// This method adds a new clothing item to the wardrobe.
  /// The item is added to the in-memory list.
  /// 
  /// Returns true if the item was added successfully.
  bool addClothing(ClothingItem item) {
    try {
      _clothingList.add(item);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Add a new clothing item (alias for addClothing)
  bool addClothingItem(ClothingItem item) {
    return addClothing(item);
  }

  /// Mark a clothing item as worn (move to laundry)
  /// 
  /// Sets the item status to "In Laundry" and sets laundryUntil to 2 days from now.
  /// 
  /// Returns true if successful, false if item not found.
  bool markAsWorn(String id) {
    final item = getById(id);
    if (item == null) return false;

    final updatedItem = item.copyWith(
      status: 'In Laundry',
      laundryUntil: DateTime.now().add(const Duration(days: 2)),
    );

    return updateClothingItem(updatedItem);
  }

  /// Mark a clothing item as available (laundry done)
  /// 
  /// Sets the item status to "Available" and clears the laundryUntil date.
  /// 
  /// Returns true if successful, false if item not found.
  bool markAsAvailable(String id) {
    final item = getById(id);
    if (item == null) return false;

    final updatedItem = item.copyWith(
      status: 'Available',
      laundryUntil: null,
    );

    return updateClothingItem(updatedItem);
  }

  /// Check laundry status and automatically mark items as available
  /// 
  /// If current date is >= laundryUntil, automatically sets status to "Available"
  /// and clears the laundryUntil date.
  void checkLaundryStatus() {
    final now = DateTime.now();
    
    for (int i = 0; i < _clothingList.length; i++) {
      final item = _clothingList[i];
      
      // If item is in laundry and laundry period has ended
      if (item.status == 'In Laundry' && 
          item.laundryUntil != null && 
          now.isAfter(item.laundryUntil!)) {
        // Mark as available
        _clothingList[i] = item.copyWith(
          status: 'Available',
          laundryUntil: null,
        );
      }
    }
  }

  /// Get remaining laundry days for an item
  /// 
  /// Returns the number of days remaining until laundry is done.
  /// Returns 0 if laundryUntil is null or in the past.
  int getRemainingLaundryDays(String id) {
    final item = getById(id);
    if (item == null || item.laundryUntil == null) {
      return 0;
    }

    final now = DateTime.now();
    final difference = item.laundryUntil!.difference(now);
    
    if (difference.isNegative) {
      return 0;
    }

    return difference.inDays + 1;
  }

  /// Update an existing clothing item
  bool updateClothingItem(ClothingItem item) {
    final index = _clothingList.indexWhere((cloth) => cloth.id == item.id);
    if (index != -1) {
      _clothingList[index] = item;
      return true;
    }
    return false;
  }

  /// Delete a clothing item by id
  bool deleteClothingItem(String id) {
    final initialLength = _clothingList.length;
    _clothingList.removeWhere((item) => item.id == id);
    return _clothingList.length < initialLength;
  }

  /// Get total number of clothing items
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
  Map<String, int> getCategoryCount() {
    final Map<String, int> categoryCount = {};
    for (var item in _clothingList) {
      categoryCount[item.category] =
          (categoryCount[item.category] ?? 0) + 1;
    }
    return categoryCount;
  }

  /// Clear all clothing items
  void clearAll() {
    _clothingList.clear();
  }

  /// Reset to dummy data
  void resetDummyData() {
    _clothingList.clear();
    _initializeDummyData();
  }
}
