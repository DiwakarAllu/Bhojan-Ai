import 'package:flutter/material.dart';

class NutritionInfoCard extends StatelessWidget {
  final Map<String, dynamic> nutritionData;

  NutritionInfoCard({super.key, required this.nutritionData});

  final List<Map<String, dynamic>> nutritionItems = [
    {
      "name": "Calories",
      "key": "calories",
      "icon": Icons.local_fire_department,
      "unit": "kcal"
    },
    {
      "name": "Carbs",
      "key": "carbohydrate",
      "icon": Icons.bakery_dining,
      "unit": "g"
    },
    {
      "name": "Protein",
      "key": "protein",
      "icon": Icons.fitness_center,
      "unit": "g"
    },
    {"name": "Fat", "key": "fat", "icon": Icons.water_drop, "unit": "g"},
    {"name": "Sugar", "key": "sugar", "icon": Icons.cake, "unit": "g"},
    {"name": "Salt", "key": "salt", "icon": Icons.spa, "unit": "g"},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nutritional Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("(per 100g of food item)",
                style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true, 
              physics:
                  NeverScrollableScrollPhysics(), 
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2, 
              ),
              itemCount: nutritionItems.length,
              itemBuilder: (context, index) {
                var item = nutritionItems[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(item["icon"],
                            size: 30, color: Colors.teal), 
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["name"],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)), 
                            Text(
                                "${nutritionData[item['key']]} ${item['unit']}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors
                                        .grey[700])), 
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
