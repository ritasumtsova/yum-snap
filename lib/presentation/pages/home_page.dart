import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yam_snap/presentation/cubits/date/date_cubit.dart';
import 'package:yam_snap/presentation/cubits/meals/meal_cubit.dart';
import 'package:yam_snap/presentation/pages/camera_page.dart';
import 'package:yam_snap/shared/utils/camera_permission_handler.dart';
import 'package:yam_snap/shared/widgets/meal_card.dart';
import 'package:yam_snap/shared/widgets/no_meals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 10000);
  int currentPage = 10000;

  @override
  void initState() {
    super.initState();

    final selectedDate = context.read<SelectedDateCubit>().state;
    context.read<MealCubit>().loadMealsForDate(selectedDate);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateCubit = context.read<SelectedDateCubit>();

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<SelectedDateCubit, DateTime>(
          builder: (context, date) {
            final formattedDate = DateFormat('dd MMMM yyyy').format(date);
            return Text(formattedDate);
          },
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            final diff = index - currentPage;

            if (diff > 0) {
              selectedDateCubit.getNextDay();
            } else if (diff < 0) {
              selectedDateCubit.getPrevDay();
            }

            final selectedDate = context.read<SelectedDateCubit>().state;
            context.read<MealCubit>().loadMealsForDate(selectedDate);

            currentPage = index;
          },
          itemBuilder: (context, index) {
            return BlocBuilder<MealCubit, MealState>(
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
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        onPressed: () async {
          final hasPermission =
              await CameraPermissionHandler.checkAndRequestPermission(context);

          if (hasPermission == true && mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CameraPage()),
            );
          }
        },
        tooltip: 'Add new meal',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
