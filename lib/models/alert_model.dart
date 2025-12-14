// lib/models/alert_model.dart
class AlertModel {
  final String id;
  final String title;
  final String description;
  final String type; // weather, road, festival, safety
  final String location;
  final DateTime validFrom;
  final DateTime validTo;
  final String severity; // low, medium, high
  final bool isActive;

  AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.validFrom,
    required this.validTo,
    required this.severity,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'validFrom': validFrom.toIso8601String(),
      'validTo': validTo.toIso8601String(),
      'severity': severity,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      type: map['type'] as String,
      location: map['location'] as String,
      validFrom: DateTime.parse(map['validFrom'] as String),
      validTo: DateTime.parse(map['validTo'] as String),
      severity: map['severity'] as String,
      isActive: (map['isActive'] == 1 || map['isActive'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'validFrom': validFrom.toIso8601String(),
      'validTo': validTo.toIso8601String(),
      'severity': severity,
      'isActive': isActive,
    };
  }

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      validFrom: DateTime.parse(json['validFrom'] as String),
      validTo: DateTime.parse(json['validTo'] as String),
      severity: json['severity'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  AlertModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? location,
    DateTime? validFrom,
    DateTime? validTo,
    String? severity,
    bool? isActive,
  }) {
    return AlertModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      location: location ?? this.location,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      severity: severity ?? this.severity,
      isActive: isActive ?? this.isActive,
    );
  }

  // Helper method to check if alert is currently valid
  bool isCurrentlyValid() {
    final now = DateTime.now();
    return isActive && now.isAfter(validFrom) && now.isBefore(validTo);
  }

  // Helper method to get remaining validity time
  Duration getRemainingTime() {
    final now = DateTime.now();
    if (now.isAfter(validTo)) {
      return Duration.zero;
    }
    return validTo.difference(now);
  }
}
