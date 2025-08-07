import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yam_snap/domain/meal_form_state.dart';

class MealFormCubit extends Cubit<MealFormState> {
  MealFormCubit() : super(MealFormState());

  void updateTitle(String title) {
    emit(
      state.copyWith(
        title: title,
        isValid: _validate(title, state.calories, state.ingredients),
      ),
    );
  }

  void updateCalories(String calories) {
    emit(
      state.copyWith(
        calories: calories,
        isValid: _validate(state.title, calories, state.ingredients),
      ),
    );
  }

  void updateIngredients(String ingredients) {
    emit(
      state.copyWith(
        ingredients: ingredients,
        isValid: _validate(state.title, state.calories, ingredients),
      ),
    );
  }

  bool _validate(String title, String calories, String ingredients) {
    return title.isNotEmpty &&
        int.tryParse(calories) != null &&
        ingredients.isNotEmpty;
  }

  void reset() => emit(MealFormState());
}
