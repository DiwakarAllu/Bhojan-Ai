import 'package:flutter/material.dart';

class MyPlateScreen extends StatelessWidget {
  const MyPlateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Plate for the Day"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zoomable Image
            InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://i.ibb.co/FL74NZfw/plate-for-the-day-f.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Title
            Center(
              child: Text(
                "Today’s Balanced Plate",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "This plan represents a healthy mix of food groups to meet a 2000 Kcal daily requirement, promoting balance, variety, and essential nutrients.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),

            // Nutrient Table
            Center(
              child: Text(
                "Food Group Breakdown (2000 Kcal)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            _buildNutritionTable(),
            SizedBox(height: 24),

            // Notes Section
            Text(
              "Notes & Dietary Tips:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildNotePoints(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Nutritional Table
  Widget _buildNutritionTable() {
    final headers = [
      "Food Group",
      "Qty",
      "% Energy",
      "Energy (Kcal)",
      "Protein (g)",
      "Fat (g)",
      "Carbs (g)"
    ];

    final rows = [
      ["Cereals (incl. millets)", "250g", "43%", "841", "25", "5", "172"],
      ["Pulses", "85g", "14%", "274", "20", "3", "42"],
      ["Milk/Curd", "300ml", "11%", "216", "10", "12", "13"],
      ["Green Leafy Veg", "400g", "9%", "174", "10", "2", "28"],
      ["Fruits", "100g", "3%", "56", "1", "1", "11"],
      ["Nuts & Seeds", "35g", "9%", "181", "6", "15", "14"],
      ["Fats & Oils", "27g", "12%", "243", "-", "27", "-"],
    ];

    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1.2),
        5: FlexColumnWidth(1.2),
        6: FlexColumnWidth(1.2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.teal[100]),
          children: headers
              .map((header) => Padding(
                    padding: EdgeInsets.all(1),
                    child: Text(header,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ))
              .toList(),
        ),
        ...rows.map(
          (row) => TableRow(
            children: row
                .map((cell) => Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(cell),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  // Dietary Notes
  Widget _buildNotePoints() {
    final List<String> notes = [
      "Sugar may be consumed but limited to 25–30 grams/day. Reduce cereals to balance calories.",
      "Eggs, fish, or meat can substitute a portion of pulses.",
      "Consume vegetables (excluding potatoes) either cooked or as salad.",
      "Prefer fresh fruits over fruit juices.",
      "Use a variety of oils, vegetables, fruits, nuts, etc., to obtain a wide range of nutrients.",
      "'My Plate for the Day' is a general guideline for a 2000 Kcal diet.",
      "Individuals trying to lose weight should reduce cereal intake.",
      "Not recommended for people with specific medical conditions.",
      "Always wash raw vegetables and fruits thoroughly before cutting or peeling."
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: notes
          .map((note) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• ",
                        style: TextStyle(fontSize: 16, color: Colors.teal)),
                    Expanded(
                      child: Text(note, style: TextStyle(fontSize: 14,color: Colors.grey)),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
