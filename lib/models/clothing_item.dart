/// Model representing a clothing item in the closet
class ClothingItem {
  /// Unique identifier for the clothing item
  final String id;

  /// Name/description of the clothing item
  final String name;

  /// Category of the clothing item (Shirt, T-Shirt, Pant, Jeans, Shoe, Sandal, Chappal)
  final String category;

  /// Color of the clothing item
  final String color;

  /// Current status of the clothing item (Available, In Laundry, Damaged, Archive)
  final String status;

  /// Date when the clothing item was added
  final DateTime dateAdded;

  /// Date until which the clothing item is in laundry (null if not in laundry)
  final DateTime? laundryUntil;

  /// Path to the clothing item image (null if no image)
  final String? imagePath;

  /// Constructor for ClothingItem
  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.status,
    required this.dateAdded,
    this.laundryUntil,
    this.imagePath,
  });

  /// Create a copy of this ClothingItem with optional field updates
  ClothingItem copyWith({
    String? id,
    String? name,
    String? category,
    String? color,
    String? status,
    DateTime? dateAdded,
    DateTime? laundryUntil,
    String? imagePath,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      color: color ?? this.color,
      status: status ?? this.status,
      dateAdded: dateAdded ?? this.dateAdded,
      laundryUntil: laundryUntil ?? this.laundryUntil,
      imagePath: imagePath ?? this.imagePath,
    );
  }

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
      'imagePath': imagePath,
    };
  }

  /// Create ClothingItem from JSON
  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      color: json['color'] as String,
      status: json['status'] as String,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      laundryUntil: json['laundryUntil'] != null
          ? DateTime.parse(json['laundryUntil'] as String)
          : null,
      imagePath: json['imagePath'] as String?,
    );
  }
}