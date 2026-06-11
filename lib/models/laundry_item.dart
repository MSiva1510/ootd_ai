enum LaundryStatus { pending, inProgress, completed }

class LaundryItem {
  final String id;
  final String clothingItemId;
  final String clothingItemName;
  final LaundryStatus status;
  final DateTime dateAdded;
  final DateTime? completionDate;
  final String notes;
  final String? washType; // delicate, normal, heavy

  LaundryItem({
    required this.id,
    required this.clothingItemId,
    required this.clothingItemName,
    this.status = LaundryStatus.pending,
    required this.dateAdded,
    this.completionDate,
    this.notes = '',
    this.washType,
  });

  factory LaundryItem.fromJson(Map<String, dynamic> json) {
    return LaundryItem(
      id: json['id'] as String,
      clothingItemId: json['clothingItemId'] as String,
      clothingItemName: json['clothingItemName'] as String,
      status: LaundryStatus.values[json['status'] as int? ?? 0],
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      notes: json['notes'] as String? ?? '',
      washType: json['washType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clothingItemId': clothingItemId,
      'clothingItemName': clothingItemName,
      'status': status.index,
      'dateAdded': dateAdded.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'notes': notes,
      'washType': washType,
    };
  }
}
