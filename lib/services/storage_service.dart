import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static Future<void> saveFavorite(Map<String, dynamic> food) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    // Add timestamp to food object
    food['timestamp'] = DateTime.now().toString();

    favorites.add(jsonEncode(food));
    await prefs.setStringList('favorites', favorites);
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    return favorites
        .map<Map<String, dynamic>>(
            (food) => jsonDecode(food) as Map<String, dynamic>)
        .toList();
  }

  static Future<void> deleteFavorite(Map<String, dynamic> foodToDelete) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    // Remove the selected item
    favorites.removeWhere((food) {
      Map<String, dynamic> decodedFood =
          jsonDecode(food) as Map<String, dynamic>;
      return decodedFood['nutritional_info']['name'] ==
              foodToDelete['nutritional_info']['name'] &&
          decodedFood['timestamp'] == foodToDelete['timestamp'];
    });

    await prefs.setStringList('favorites', favorites);
  }
}

// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class StorageService {
//   static Future<void> saveFavorite(Map<String, dynamic> food) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> favorites = prefs.getStringList('favorites') ?? [];
//     favorites.add(jsonEncode(food));
//     await prefs.setStringList('favorites', favorites);
//   }

//   static Future<List<Map<String, dynamic>>> getFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> favorites = prefs.getStringList('favorites') ?? [];
//     return favorites.map<Map<String, dynamic>>((food) => jsonDecode(food) as Map<String, dynamic>).toList();
//   }
// }
