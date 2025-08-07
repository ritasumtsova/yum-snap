import 'package:hive/hive.dart';

part 'meal_model.g.dart';

@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(1)
  final String title;

  @HiveField(2)
  final int calories;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String imagePath;

  @HiveField(5)
  final String ingredients;

  Meal({
    required this.title,
    required this.calories,
    required this.date,
    required this.imagePath,
    required this.ingredients,
  });

  Meal copyWith({
    String? id,
    String? title,
    int? calories,
    DateTime? date,
    String? imagePath,
    String? ingredients,
  }) {
    return Meal(
      title: title ?? this.title,
      calories: calories ?? this.calories,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'calories': calories,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
      'ingredients': ingredients,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      title: json['title'] as String,
      calories: json['calories'] as int,
      date: DateTime.parse(json['date'] as String),
      imagePath: json['imagePath'] as String,
      ingredients: json['ingredients'] as String,
    );
  }

  @override
  String toString() {
    return 'Meal(title: $title, calories: $calories, date: $date, imagePath: $imagePath, ingredients: $ingredients)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Meal &&
        other.title == title &&
        other.calories == calories &&
        other.date == date &&
        other.imagePath == imagePath &&
        other.ingredients == ingredients;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        calories.hashCode ^
        date.hashCode ^
        imagePath.hashCode ^
        ingredients.hashCode;
  }
}
