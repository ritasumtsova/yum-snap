import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yam_snap/domain/date_cubit.dart';
import 'package:yam_snap/domain/meal_cubit.dart';
import 'package:yam_snap/domain/meal_state.dart';
import 'package:yam_snap/presentation/camera_page.dart';
import 'package:yam_snap/shared/widgets/meal_card.dart';
import 'package:yam_snap/shared/widgets/no_meals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final selectedDate = context.read<SelectedDateCubit>().state;
    context.read<MealCubit>().loadMealsForDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectedDateCubit, DateTime>(
      listener: (context, selectedDate) {
        context.read<MealCubit>().loadMealsForDate(selectedDate);
      },
      child: BlocBuilder<SelectedDateCubit, DateTime>(
        builder: (context, selectedDate) {
          final formattedDate = DateFormat.MMMMd().format(selectedDate);
          final selectedDateCubit = context.read<SelectedDateCubit>();

          return Scaffold(
            appBar: AppBar(
              title: Text(formattedDate),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => selectedDateCubit.getPrevDay(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => selectedDateCubit.getNextDay(),
                ),
              ],
            ),
            body: GestureDetector(
              onHorizontalDragEnd: (details) {
                details.primaryVelocity! > 0
                    ? selectedDateCubit.getPrevDay()
                    : selectedDateCubit.getNextDay();
              },
              child: BlocBuilder<MealCubit, MealState>(
                builder: (context, state) {
                  if (state is MealLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MealLoaded) {
                    final meals = state.meals;
                    return meals.isEmpty
                        ? const NoMeals()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: meals.length,
                            itemBuilder: (context, index) {
                              return MealCard(meal: meals[index]);
                            },
                          );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraPage()),
                );
              },
              tooltip: 'Add new meal',
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
