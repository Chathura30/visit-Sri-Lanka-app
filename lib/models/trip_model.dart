// lib/models/trip_model.dart
class TripModel {
  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int duration;
  final List<String> cities;
  final bool isSynced;
  final DateTime createdAt;

  TripModel({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.cities,
    this.isSynced = false,
    required this.createdAt,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'duration': duration,
      'cities': cities.join(','),
      'isSynced': isSynced ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Map
  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'] as String,
      name: map['name'] as String,
      destination: map['destination'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      duration: map['duration'] as int,
      cities: (map['cities'] as String).split(','),
      isSynced: (map['isSynced'] == 1 || map['isSynced'] == true),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Create copy with updated values
  TripModel copyWith({
    String? id,
    String? name,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    int? duration,
    List<String>? cities,
    bool? isSynced,
    DateTime? createdAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      name: name ?? this.name,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      duration: duration ?? this.duration,
      cities: cities ?? this.cities,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'duration': duration,
      'cities': cities,
      'isSynced': isSynced,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      name: json['name'] as String,
      destination: json['destination'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      duration: json['duration'] as int,
      cities: List<String>.from(json['cities'] as List),
      isSynced: json['isSynced'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
