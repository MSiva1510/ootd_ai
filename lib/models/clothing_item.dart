class ClothingItem {
  final String id;
  final String name;
  final String category; // shirt, pants, shoes, accessories
  final String color;
  final String? imageUrl;
  final DateTime dateAdded;
  final List<String> tags;
  final int timesWorn;
  final DateTime? lastWorn;

  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    this.imageUrl,
    required this.dateAdded,
    this.tags = const [],
    this.timesWorn = 0,
    this.lastWorn,
  });

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      color: json['color'] as String,
      imageUrl: json['imageUrl'] as String?,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      tags: List<String>.from(json['tags'] as List? ?? []),
      timesWorn: json['timesWorn'] as int? ?? 0,
      lastWorn: json['lastWorn'] != null 
          ? DateTime.parse(json['lastWorn'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'color': color,
      'imageUrl': imageUrl,
      'dateAdded': dateAdded.toIso8601String(),
      'tags': tags,
      'timesWorn': timesWorn,
      'lastWorn': lastWorn?.toIso8601String(),
    };
  }
}
