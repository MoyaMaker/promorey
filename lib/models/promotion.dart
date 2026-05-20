import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  // imageUrl removed — Firebase Storage requires paid plan
  final bool isActive;
  final String userId;
  final DateTime createdAt;

  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    // imageUrl removed
    required this.isActive,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'date': Timestamp.fromDate(date),
    // imageUrl removed
    'isActive': isActive,
    'userId': userId,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory Promotion.fromMap(String id, Map<String, dynamic> map) => Promotion(
    id: id,
    title: map['title'] as String? ?? '',
    description: map['description'] as String? ?? '',
    date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    // imageUrl removed
    isActive: map['isActive'] as bool? ?? true,
    userId: map['userId'] as String? ?? '',
    createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );

  Promotion copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    // imageUrl removed
    bool? isActive,
    String? userId,
    DateTime? createdAt,
  }) => Promotion(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    date: date ?? this.date,
    // imageUrl removed
    isActive: isActive ?? this.isActive,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
  );
}
