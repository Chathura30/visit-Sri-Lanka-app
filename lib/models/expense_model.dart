// lib/models/expense_model.dart
class ExpenseModel {
  final String id;
  final String tripId;
  final String category;
  final double amount;
  final String currency;
  final double amountInLKR;
  final String description;
  final DateTime date;
  final bool isSynced;

  ExpenseModel({
    required this.id,
    required this.tripId,
    required this.category,
    required this.amount,
    required this.currency,
    required this.amountInLKR,
    required this.description,
    required this.date,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'category': category,
      'amount': amount,
      'currency': currency,
      'amountInLKR': amountInLKR,
      'description': description,
      'date': date.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as String,
      tripId: map['tripId'] as String,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      amountInLKR: (map['amountInLKR'] as num).toDouble(),
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
      isSynced: (map['isSynced'] == 1 || map['isSynced'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'category': category,
      'amount': amount,
      'currency': currency,
      'amountInLKR': amountInLKR,
      'description': description,
      'date': date.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      amountInLKR: (json['amountInLKR'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  ExpenseModel copyWith({
    String? id,
    String? tripId,
    String? category,
    double? amount,
    String? currency,
    double? amountInLKR,
    String? description,
    DateTime? date,
    bool? isSynced,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      amountInLKR: amountInLKR ?? this.amountInLKR,
      description: description ?? this.description,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
