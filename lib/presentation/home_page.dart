import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yam_snap/domain/meal_data.dart';
import 'package:yam_snap/data/meal_model.dart';
import 'package:yam_snap/presentation/camera_page.dart';
import 'package:yam_snap/shared/widgets/meal_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  List<Meal> _mealsForDate = [];

  String get formattedDate => DateFormat.MMMMd().format(_selectedDate);

  @override
  void initState() {
    super.initState();
    _loadMealsForDate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMealsForDate();
  }

  void _loadMealsForDate() {
    setState(() {
      _mealsForDate = MealDataService.getMealsForDate(_selectedDate);
    });
  }

  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    _loadMealsForDate();
  }

  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    _loadMealsForDate();
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      _goToPreviousDay();
    } else if (details.primaryVelocity! < 0) {
      _goToNextDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goToPreviousDay,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _goToNextDay,
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: _handleSwipe,
        child: _mealsForDate.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant,
                      size: 64,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No meals',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to add your first meal!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _mealsForDate.length,
                itemBuilder: (context, index) {
                  return MealCard(meal: _mealsForDate[index]);
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
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
  }
}
