import 'package:hive_flutter/hive_flutter.dart';
import 'package:yam_snap/data/meal_model.dart';
import 'dart:math';

class MealDataService {
  static const String _boxName = 'meals';
  static Box<Meal>? _box;

  static Future<void> initialize() async {
    _box = await Hive.openBox<Meal>(_boxName);
  }

  static String generateId() {
    const chars = '0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        8,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  static List<Meal> getAllMeals() {
    if (_box == null) {
      throw Exception(
        'MealDataService not initialized. Call initialize() first.',
      );
    }
    return _box!.values.toList();
  }

  static List<Meal> getMealsForDate(DateTime date) {
    final allMeals = getAllMeals();
    return allMeals.where((meal) {
      return meal.date.year == date.year &&
          meal.date.month == date.month &&
          meal.date.day == date.day;
    }).toList();
  }

  static Future<void> addMeal(Meal meal) async {
    if (_box == null) {
      throw Exception(
        'MealDataService not initialized. Call initialize() first.',
      );
    }
    await _box!.add(meal);
  }

  static Future<Meal> addMealWithId({
    required String title,
    required int calories,
    required DateTime date,
    required String imagePath,
    required String ingredients,
    String? id,
  }) async {
    final mealId = id ?? generateId();
    final meal = Meal(
      id: mealId,
      title: title,
      calories: calories,
      date: date,
      imagePath: imagePath,
      ingredients: ingredients,
    );

    await addMeal(meal);
    return meal;
  }

  static Future<void> close() async {
    await _box?.close();
  }
}
