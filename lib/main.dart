import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yam_snap/domain/models/meal_model.dart';
import 'package:yam_snap/data/services/meal_data.dart';
import 'package:yam_snap/domain/use_cases/add_meal.dart';
import 'package:yam_snap/domain/use_cases/get_meals_for_date.dart';
import 'package:yam_snap/presentation/cubits/camera/camera_cubit.dart';
import 'package:yam_snap/presentation/cubits/date/date_cubit.dart';
import 'package:yam_snap/presentation/cubits/meals/meal_cubit.dart';
import 'package:yam_snap/presentation/cubits/form/meal_form_cubit.dart';
import 'package:yam_snap/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MealAdapter());

  await MealDataService.initialize();

  final getMealsForDate = GetMealsForDate(MealDataService());
  final addMeal = AddMeal(MealDataService());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SelectedDateCubit()),
        BlocProvider(
          create: (_) =>
              MealCubit(getMealsForDate: getMealsForDate, addMeal: addMeal),
        ),
        BlocProvider(create: (_) => MealFormCubit()),
        BlocProvider(create: (_) => CameraCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yam Snap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const HomePage(),
    );
  }
}
