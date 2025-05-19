import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../services/storage_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favorites = [];
  int? longPressedIndex; 

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    var data = await StorageService.getFavorites();
    setState(() {
      favorites = data;
    });
  }

  String _formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('dd-MM-yyyy HH:mm')
        .format(dateTime); 
  }

  void _showNutritionDetails(Map<String, dynamic> food) {
    final info = food['nutritional_info'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(info['name'], style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Saved on: ${_formatDate(food['timestamp'])}"), 
            Divider(),
            DataTable(
              columns: [
                DataColumn(
                    label: Text("Nutrient",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Amount")),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text("Calories")),
                  DataCell(Text("${info['calories']} kcal"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Carbs")),
                  DataCell(Text("${info['carbohydrate']} g"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Protein")),
                  DataCell(Text("${info['protein']} g"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Fat")),
                  DataCell(Text("${info['fat']} g"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Sugar")),
                  DataCell(Text("${info['sugar']} g"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Salt")),
                  DataCell(Text("${info['salt']} g"))
                ]),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Close")),
        ],
      ),
    );
  }

  void _deleteFavorite(Map<String, dynamic> food) async {
    await StorageService.deleteFavorite(food);
    _loadFavorites(); 
  }

  Widget _buildDeleteButton(Map<String, dynamic> food) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        _deleteFavorite(food); 
        setState(() {
          longPressedIndex = null; 
        });
      },
    );
  }

  void _handleTap() {
    setState(() {
      longPressedIndex = null; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorites"), backgroundColor: Colors.teal),
      body: GestureDetector(
        onTap: _handleTap, 
        child: favorites.isEmpty
            ? Center(
                child: Text("No favorites saved yet!",
                    style: TextStyle(fontSize: 18)))
            : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final food = favorites[index];

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: Icon(Icons.favorite, color: Colors.redAccent),
                      title: Text(
                        food['nutritional_info']['name'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Calories: ${food['nutritional_info']['calories']} kcal\nSaved on: ${_formatDate(food['timestamp'])}", // Format date here
                      ),
                      onTap: () => _showNutritionDetails(food),
                      onLongPress: () {
                        setState(() {
                          longPressedIndex =
                              index; 
                        });
                      },
                      trailing: longPressedIndex == index
                          ? _buildDeleteButton(
                              food) 
                          : null, 
                    ),
                  );
                },
              ),
      ),
    );
  }
}

