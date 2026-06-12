/// Model representing an outfit combination
class Outfit {
  final String id;
  final DateTime date;
  final String shirtId;
  final String pantId;
  final String footwearId;

  // --- Added fields for history / favorites / dashboard support ---
  final String title;
  final String? description;
  final List<String> itemIds; // IDs of ClothingItems (general list, e.g. for History UI)
  final DateTime createdAt;
  final int ratings; // 0-5 scale
  final String? occasion;
  final String? weatherSuitable; // sunny, rainy, cold, hot
  final List<String> tags;
  final bool isFavorite;

  /// Constructor
  Outfit({
    required this.id,
    required this.date,
    required this.shirtId,
    required this.pantId,
    required this.footwearId,
    String? title,
    this.description,
    List<String>? itemIds,
    DateTime? createdAt,
    this.ratings = 0,
    this.occasion,
    this.weatherSuitable,
    this.tags = const [],
    this.isFavorite = false,
  })  : title = title ?? 'Outfit',
        itemIds = itemIds ?? const [],
        createdAt = createdAt ?? date;

  /// Convert Outfit to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'shirtId': shirtId,
      'pantId': pantId,
      'footwearId': footwearId,
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

  /// Create Outfit from JSON
  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      shirtId: json['shirtId'] as String,
      pantId: json['pantId'] as String,
      footwearId: json['footwearId'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      itemIds: List<String>.from(json['itemIds'] as List? ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      ratings: json['ratings'] as int? ?? 0,
      occasion: json['occasion'] as String?,
      weatherSuitable: json['weatherSuitable'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  /// Create a copy of Outfit with modified fields
  Outfit copyWith({
    String? id,
    DateTime? date,
    String? shirtId,
    String? pantId,
    String? footwearId,
    String? title,
    String? description,
    List<String>? itemIds,
    DateTime? createdAt,
    int? ratings,
    String? occasion,
    String? weatherSuitable,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return Outfit(
      id: id ?? this.id,
      date: date ?? this.date,
      shirtId: shirtId ?? this.shirtId,
      pantId: pantId ?? this.pantId,
      footwearId: footwearId ?? this.footwearId,
      title: title ?? this.title,
      description: description ?? this.description,
      itemIds: itemIds ?? this.itemIds,
      createdAt: createdAt ?? this.createdAt,
      ratings: ratings ?? this.ratings,
      occasion: occasion ?? this.occasion,
      weatherSuitable: weatherSuitable ?? this.weatherSuitable,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Outfit(id: $id, date: $date, shirt: $shirtId, pant: $pantId, footwear: $footwearId)';
  }
}