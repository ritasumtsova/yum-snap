import 'package:hive_flutter/hive_flutter.dart';
import 'package:yam_snap/domain/models/meal_model.dart';

class MealDataService {
  static const String _boxName = 'meals';
  static Box<Meal>? _box;

  static Future<void> initialize() async {
    _box = await Hive.openBox<Meal>(_boxName);
  }

  static List<Meal> getAllMeals() {
    if (_box == null) {
      throw Exception(
        'MealDataService not initialized. Call initialize() first.',
      );
    }
    return _box!.values.toList();
  }

  List<Meal> getMealsForDate(DateTime date) {
    final allMeals = getAllMeals();
    return allMeals.where((meal) {
      return meal.date.year == date.year &&
          meal.date.month == date.month &&
          meal.date.day == date.day;
    }).toList();
  }

  Future<void> addMeal(Meal meal) async {
    if (_box == null) {
      throw Exception(
        'MealDataService not initialized. Call initialize() first.',
      );
    }
    await _box?.add(meal);
  }

  Future<void> close() async {
    await _box?.close();
  }
}
