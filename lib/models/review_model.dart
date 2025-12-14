// lib/models/review_model.dart
class ReviewModel {
  final String id;
  final String destinationId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;
  final bool isSynced;

  ReviewModel({
    required this.id,
    required this.destinationId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destinationId': destinationId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String,
      destinationId: map['destinationId'] as String,
      userName: map['userName'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      date: DateTime.parse(map['date'] as String),
      isSynced: (map['isSynced'] == 1 || map['isSynced'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destinationId': destinationId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      destinationId: json['destinationId'] as String,
      userName: json['userName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  ReviewModel copyWith({
    String? id,
    String? destinationId,
    String? userName,
    double? rating,
    String? comment,
    DateTime? date,
    bool? isSynced,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      destinationId: destinationId ?? this.destinationId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
