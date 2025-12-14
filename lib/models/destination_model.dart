// lib/models/destination_model.dart
class DestinationModel {
  final String id;
  final String name;
  final String province;
  final String category;
  final String description;
  final String imageUrl;
  final String bestTimeToVisit;
  final bool isSaved;

  DestinationModel({
    required this.id,
    required this.name,
    required this.province,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.bestTimeToVisit,
    this.isSaved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'province': province,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'bestTimeToVisit': bestTimeToVisit,
      'isSaved': isSaved ? 1 : 0,
    };
  }

  factory DestinationModel.fromMap(Map<String, dynamic> map) {
    return DestinationModel(
      id: map['id'] as String,
      name: map['name'] as String,
      province: map['province'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String? ?? '',
      bestTimeToVisit: map['bestTimeToVisit'] as String,
      isSaved: (map['isSaved'] == 1 || map['isSaved'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'province': province,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'bestTimeToVisit': bestTimeToVisit,
      'isSaved': isSaved,
    };
  }

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      province: json['province'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      bestTimeToVisit: json['bestTimeToVisit'] as String,
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  DestinationModel copyWith({
    String? id,
    String? name,
    String? province,
    String? category,
    String? description,
    String? imageUrl,
    String? bestTimeToVisit,
    bool? isSaved,
  }) {
    return DestinationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      province: province ?? this.province,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      bestTimeToVisit: bestTimeToVisit ?? this.bestTimeToVisit,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
