part of 'meal_cubit.dart';

abstract class MealState {
  const MealState();
}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealLoaded extends MealState {
  final List<Meal> meals;

  const MealLoaded(this.meals);
}

class MealError extends MealState {
  final String message;

  const MealError(this.message);
}
