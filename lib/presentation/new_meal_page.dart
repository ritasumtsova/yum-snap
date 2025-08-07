import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yam_snap/data/meal_model.dart';
import 'package:yam_snap/domain/meal_cubit.dart';
import 'package:yam_snap/presentation/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewMealPage extends StatefulWidget {
  const AddNewMealPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<AddNewMealPage> createState() => _AddNewMealPageState();
}

class _AddNewMealPageState extends State<AddNewMealPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _today = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.reset();
    _titleController.dispose();
    _caloriesController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _caloriesController.clear();
    _ingredientsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Image.file(File(widget.imagePath), fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a meal title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _caloriesController,
                    decoration: InputDecoration(
                      labelText: 'Calories',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter calories';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _ingredientsController,
                    decoration: InputDecoration(
                      labelText: 'Ingredients',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ingredients';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final mealCubit = context.read<MealCubit>();

                          final meal = Meal(
                            title: _titleController.text,
                            calories: int.parse(_caloriesController.text),
                            date: _today,
                            imagePath: widget.imagePath,
                            ingredients: _ingredientsController.text,
                          );

                          mealCubit.addMeal(meal);

                          if (meal.isInBox && mounted) {
                            _clearForm();
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
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    child: const Text('Done', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
