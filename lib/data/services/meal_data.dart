import 'package:hive_flutter/hive_flutter.dart';
import 'package:yam_snap/domain/models/meal_model.dart';
import 'package:intl/intl.dart';

class MealDataService {
  static const String _boxName = 'meals_by_date';
  static Box<List>? _box;

  static Future<void> initialize() async {
    _box = await Hive.openBox<List>(_boxName);
  }

  static String _dateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  List<Meal> getMealsForDate(DateTime date) {
    if (_box == null) throw Exception("Box not initialized");

    final key = _dateKey(date);
    final meals = _box!.get(key, defaultValue: <Meal>[]);
    return meals!.cast<Meal>();
  }

  Future<void> addMeal(Meal meal) async {
    if (_box == null) throw Exception("Box not initialized");

    final date = DateTime.now();
    final key = _dateKey(date);
    final meals = _box!.get(key, defaultValue: <Meal>[])!.cast<Meal>();
    meals.add(meal);

    await _box!.put(key, meals);
  }

  Future<void> close() async {
    await _box?.close();
  }
}
