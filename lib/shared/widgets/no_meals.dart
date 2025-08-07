import 'package:flutter/material.dart';

class NoMeals extends StatelessWidget {
  const NoMeals({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.restaurant, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No meals', style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 8),
          Text(
            'Tap the + button to add your first meal!',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
