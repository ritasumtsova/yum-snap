import 'package:yam_snap/data/services/meal_data.dart';
import 'package:yam_snap/domain/models/meal_model.dart';

class GetMealsForDate {
  final MealDataService _mealDataService;

  GetMealsForDate(this._mealDataService);

  List<Meal> call(DateTime date) {
    return _mealDataService.getMealsForDate(date);
  }
}
