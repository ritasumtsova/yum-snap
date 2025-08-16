import 'package:hive/hive.dart';

part 'meal_model.g.dart';

@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(1)
  final String title;

  @HiveField(2)
  final int calories;

  @HiveField(4)
  final String imagePath;

  @HiveField(5)
  final String ingredients;

  Meal({
    required this.title,
    required this.calories,
    required this.imagePath,
    required this.ingredients,
  });

  Meal copyWith({
    String? id,
    String? title,
    int? calories,
    String? imagePath,
    String? ingredients,
  }) {
    return Meal(
      title: title ?? this.title,
      calories: calories ?? this.calories,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'calories': calories,
      'imagePath': imagePath,
      'ingredients': ingredients,
    };
  }

  factory Meal.fromFormState(
    String title,
    int calories,
    String ingredients,
    String imagePath,
  ) {
    return Meal(
      title: title,
      calories: calories,
      imagePath: imagePath,
      ingredients: ingredients,
    );
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      title: json['title'] as String,
      calories: json['calories'] as int,
      imagePath: json['imagePath'] as String,
      ingredients: json['ingredients'] as String,
    );
  }
}
