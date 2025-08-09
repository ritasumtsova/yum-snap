import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yam_snap/domain/models/meal_model.dart';
import 'package:yam_snap/domain/use_cases/add_meal.dart';
import 'package:yam_snap/domain/use_cases/get_meals_for_date.dart';

part 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final GetMealsForDate getMealsForDate;
  final AddMeal addMeal;

  MealCubit({required this.getMealsForDate, required this.addMeal})
    : super(MealInitial());

  Future<void> loadMealsForDate(DateTime date) async {
    try {
      emit(MealLoading());
      final meals = getMealsForDate(date);
      emit(MealLoaded(meals));
    } catch (e) {
      emit(MealError('Failed to load meals: $e'));
    }
  }

  Future<void> addNewMeal(Meal meal) async {
    try {
      await addMeal(meal);
    } catch (e) {
      emit(MealError('Failed to add meal: $e'));
    }
  }
}
