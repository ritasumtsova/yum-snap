import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yam_snap/data/meal_model.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    const defaultPaddings = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
    return Padding(
      padding: defaultPaddings,
      child: Card(
        child: Padding(
          padding: defaultPaddings,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(meal.imagePath), fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${meal.calories} calories',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    meal.ingredients,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
