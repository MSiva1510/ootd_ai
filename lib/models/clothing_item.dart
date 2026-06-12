/// Model representing a clothing item in the wardrobe
class ClothingItem {
  final String id;
  final String name;
  final String category;
  final String color;
  final String status;
  final DateTime dateAdded;
  final DateTime? laundryUntil;

  /// Available clothing categories
  static const List<String> categories = [
    'Shirt',
    'T-Shirt',
    'Pant',
    'Jeans',
    'Shoe',
    'Sandal',
    'Chappal',
  ];

  /// Available status options
  static const List<String> statusOptions = [
    'Available',
    'In Laundry',
    'Damaged',
    'Archive',
  ];

  /// Constructor
  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.status,
    required this.dateAdded,
    this.laundryUntil,
  });

  /// Convert ClothingItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'color': color,
      'status': status,
      'dateAdded': dateAdded.toIso8601String(),
      'laundryUntil': laundryUntil?.toIso8601String(),
    };
  }

  /// Create ClothingItem from JSON
  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      color: json['color'] as String,
      status: json['status'] as String? ?? 'Available',
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      laundryUntil: json['laundryUntil'] != null
          ? DateTime.parse(json['laundryUntil'] as String)
          : null,
    );
  }

  /// Create a copy of ClothingItem with modified fields
  ClothingItem copyWith({
    String? id,
    String? name,
    String? category,
    String? color,
    String? status,
    DateTime? dateAdded,
    DateTime? laundryUntil,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      color: color ?? this.color,
      status: status ?? this.status,
      dateAdded: dateAdded ?? this.dateAdded,
      laundryUntil: laundryUntil ?? this.laundryUntil,
    );
  }

  @override
  String toString() {
    return 'ClothingItem(id: $id, name: $name, category: $category, color: $color, status: $status, laundryUntil: $laundryUntil)';
  }
}
