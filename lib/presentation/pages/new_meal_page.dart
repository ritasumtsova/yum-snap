import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yam_snap/domain/models/meal_model.dart';
import 'package:yam_snap/presentation/cubits/camera/camera_cubit.dart';
import 'package:yam_snap/presentation/cubits/meals/meal_cubit.dart';
import 'package:yam_snap/presentation/cubits/form/meal_form_cubit.dart';
import 'package:yam_snap/presentation/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yam_snap/shared/widgets/form_field.dart';

class AddNewMealPage extends StatefulWidget {
  const AddNewMealPage({super.key});

  @override
  State<AddNewMealPage> createState() => _AddNewMealPageState();
}

class _AddNewMealPageState extends State<AddNewMealPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<CameraCubit, CameraState>(
        builder: (context, state) {
          if (state is! CameraPictureTaken) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                flex: 5,
                child: Image.file(File(state.imagePath), fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: BlocBuilder<MealFormCubit, MealFormState>(
                  builder: (context, formState) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomFormField(
                            label: 'Title',
                            initialValue: formState.title,
                            onChanged: (value) => context
                                .read<MealFormCubit>()
                                .updateTitle(value),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter a meal title'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          CustomFormField(
                            label: 'Calories',
                            keyboardType: TextInputType.number,
                            initialValue: formState.calories,
                            onChanged: (value) => context
                                .read<MealFormCubit>()
                                .updateCalories(value),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomFormField(
                            label: 'Ingredients',
                            initialValue: formState.ingredients,
                            onChanged: (value) => context
                                .read<MealFormCubit>()
                                .updateIngredients(value),
                            maxLines: 3,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter ingredients'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: () async {
                              if (formState.isValid) {
                                try {
                                  final meal = Meal.fromFormState(
                                    formState.title,
                                    int.parse(formState.calories),
                                    formState.ingredients,
                                    state.imagePath,
                                  );

                                  context.read<MealCubit>().addMeal(meal);

                                  if (meal.isInBox && mounted) {
                                    context.read<MealFormCubit>().reset();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => const HomePage(),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error saving meal: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                Colors.black,
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                            child: const Text(
                              'Done',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
