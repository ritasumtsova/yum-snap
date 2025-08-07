class MealFormState {
  final String title;
  final String calories;
  final String ingredients;
  final bool isValid;

  MealFormState({
    this.title = '',
    this.calories = '',
    this.ingredients = '',
    this.isValid = false,
  });

  MealFormState copyWith({
    String? title,
    String? calories,
    String? ingredients,
    bool? isValid,
  }) {
    return MealFormState(
      title: title ?? this.title,
      calories: calories ?? this.calories,
      ingredients: ingredients ?? this.ingredients,
      isValid: isValid ?? this.isValid,
    );
  }
}
