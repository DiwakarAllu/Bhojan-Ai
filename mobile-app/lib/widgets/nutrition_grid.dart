// import 'package:flutter/material.dart';

// class NutritionCard extends StatelessWidget {
//   final String nutrient;
//   final String amount;
//   final IconData icon;

//   NutritionCard(
//       {required this.nutrient, required this.amount, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Colors.teal), // Nutrient Icon
//             SizedBox(height: 8),
//             Text(nutrient,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 6),
//             Text(amount,
//                 style: TextStyle(fontSize: 16, color: Colors.grey[700])),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NutritionGrid extends StatelessWidget {
//   final Map<String, dynamic> info;

//   NutritionGrid(this.info);

//   final List<Map<String, dynamic>> nutritionItems = [
//     {
//       "name": "Calories",
//       "amount": "200 kcal",
//       "icon": Icons.local_fire_department
//     },
//     {"name": "Carbs", "amount": "30 g", "icon": Icons.bakery_dining},
//     {"name": "Protein", "amount": "15 g", "icon": Icons.fitness_center},
//     {"name": "Fat", "amount": "10 g", "icon": Icons.water_drop},
//     {"name": "Sugar", "amount": "5 g", "icon": Icons.cake},
//     {"name": "Salt", "amount": "2 g", "icon": Icons.spa},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: GridView.builder(
//         shrinkWrap: true, // To ensure it works inside a column
//         physics:
//             NeverScrollableScrollPhysics(), // Prevent scrolling inside card
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Two-column layout
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//         ),
//         itemCount: nutritionItems.length,
//         itemBuilder: (context, index) {
//           return NutritionCard(
//             nutrient: nutritionItems[index]["name"],
//             amount: nutritionItems[index]["amount"],
//             icon: nutritionItems[index]["icon"],
//           );
//         },
//       ),
//     );
//   }
// }
