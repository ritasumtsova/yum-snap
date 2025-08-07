import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yam_snap/data/meal_model.dart';
import 'package:yam_snap/data/meal_data.dart';

part 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  MealCubit() : super(MealInitial());

  Future<void> loadMealsForDate(DateTime date) async {
    try {
      emit(MealLoading());
      final meals = MealDataService.getMealsForDate(date);
      emit(MealLoaded(meals));
    } catch (e) {
      emit(MealError('Failed to load meals: $e'));
    }
  }

  Future<void> addMeal(Meal meal) async {
    try {
      await MealDataService.addMeal(meal);
      await loadMealsForDate(meal.date);
    } catch (e) {
      emit(MealError('Failed to add meal: $e'));
    }
  }
}
