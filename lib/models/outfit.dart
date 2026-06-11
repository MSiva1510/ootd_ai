class Outfit {
  final String id;
  final String title;
  final String? description;
  final List<String> itemIds; // IDs of ClothingItems
  final DateTime createdAt;
  final int ratings; // 1-5 scale
  final String? occasion;
  final String? weatherSuitable; // sunny, rainy, cold, hot
  final List<String> tags;
  final bool isFavorite;

  Outfit({
    required this.id,
    required this.title,
    this.description,
    required this.itemIds,
    required this.createdAt,
    this.ratings = 0,
    this.occasion,
    this.weatherSuitable,
    this.tags = const [],
    this.isFavorite = false,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      itemIds: List<String>.from(json['itemIds'] as List? ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      ratings: json['ratings'] as int? ?? 0,
      occasion: json['occasion'] as String?,
      weatherSuitable: json['weatherSuitable'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'itemIds': itemIds,
      'createdAt': createdAt.toIso8601String(),
      'ratings': ratings,
      'occasion': occasion,
      'weatherSuitable': weatherSuitable,
      'tags': tags,
      'isFavorite': isFavorite,
    };
  }
}
