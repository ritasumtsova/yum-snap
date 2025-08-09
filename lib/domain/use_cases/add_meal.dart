import 'package:yam_snap/data/services/meal_data.dart';
import 'package:yam_snap/domain/models/meal_model.dart';

class AddMeal {
  final MealDataService _mealDataService;

  AddMeal(this._mealDataService);

  Future<void> call(Meal meal) async {
    await _mealDataService.addMeal(meal);
  }
}
