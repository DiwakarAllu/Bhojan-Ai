// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:url_launcher/url_launcher.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   List<Map<String, dynamic>> foodList = [];
//   Map<String, dynamic>? selectedFood;

//   @override
//   void initState() {
//     super.initState();
//     _fetchFoodData();
//   }

//   Future<void> _fetchFoodData() async {
//     final response =
//         await http.get(Uri.parse("https://api.npoint.io/6077926ba47ea13a6372"));
//     if (response.statusCode == 200) {
//       setState(() {
//         foodList = List<Map<String, dynamic>>.from(json.decode(response.body));
//       });
//     } else {
//       print("Error fetching data: ${response.statusCode}");
//     }
//   }

//   void _showFoodDetails(Map<String, dynamic> food) {
//     setState(() {
//       selectedFood = food;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Search Food"), backgroundColor: Colors.teal),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Auto-complete search bar
//             Autocomplete<String>(
//               optionsBuilder: (TextEditingValue value) {
//                 if (value.text.isEmpty) return const Iterable<String>.empty();
//                 return foodList
//                     .map<String>((food) => food['food_name'] as String)
//                     .where((name) =>
//                         name.toLowerCase().contains(value.text.toLowerCase()));
//               },
//               // onSelected: (String selection) {
//               //   _showFoodDetails(foodList
//               //       .firstWhere((food) => food['food_name'] == selection));
//               // },
//               onSelected: (String selection) {
//                 try {
//                   _showFoodDetails(foodList
//                       .firstWhere((food) => food['food_name'] == selection));
//                 } catch (e) {
//                   setState(() {
//                     selectedFood = null;
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text("Oops! No matching food item found."),
//                     duration: Duration(seconds: 2),
//                   ));
//                 }
//               },

//             ),
//             SizedBox(height: 16),

//             // Show selected food details
//             selectedFood == null
//                 ? Center(child: Text("Select a food item to view details"))
//                 : Expanded(
//                     child: SingleChildScrollView(
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                         child: Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(selectedFood!['food_name'],
//                                   style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold)),
//                               SizedBox(height: 8),

//                               // Image.network(selectedFood!['recipe']['image_url'],
//                               //     height: 150, fit: BoxFit.cover),
//                               // SizedBox(height: 8),
//                               Center(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Image.network(
//                                     selectedFood!['recipe']['image_url'],
//                                     height: 200,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 12),

//                               Text(
//                                   "Cuisine: ${selectedFood!['recipe']['Cuisine']}",
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold)),
//                               SizedBox(height: 8),
//                               Text("Ingredients:",
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold)),
//                               ...selectedFood!['recipe']['ingredients']
//                                   .split(',')
//                                   .map((ingredient) => Text("- $ingredient")),
//                               Divider(),
//                               Text("Nutritional Values:",
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold)),
//                               DataTable(
//                                 columns: [
//                                   DataColumn(
//                                       label: Text("Nutrient",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold))),
//                                   DataColumn(label: Text("Amount")),
//                                 ],
//                                 rows: selectedFood!['nutritional_values']
//                                     .entries
//                                     .map<DataRow>((entry) => DataRow(cells: [
//                                           DataCell(Text(entry.key.toString())),
//                                           DataCell(
//                                               Text(entry.value.toString())),
//                                         ]))
//                                     .toList(),
//                               ),

//                               SizedBox(height: 12),

//                               Text("Instructions:",
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold)),
//                               SizedBox(height: 8),
//                               ...selectedFood!['recipe']['instructions']
//                                   .split('\n')
//                                   .map((step) => Padding(
//                                         padding:
//                                             EdgeInsets.symmetric(vertical: 4),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Icon(Icons.arrow_forward_ios,
//                                                 size: 14, color: Colors.teal),
//                                             SizedBox(width: 8),
//                                             Expanded(
//                                                 child: Text(step,
//                                                     style: TextStyle(
//                                                         fontSize: 16))),
//                                           ],
//                                         ),
//                                       )),
//                               Divider(),

//                               SizedBox(height: 8),
//                               GestureDetector(
//                                 onTap: () =>
//                                     _launchURL(selectedFood!['recipe']['URL']),
//                                 child: Text("View Full Recipe",
//                                     style: TextStyle(
//                                         color: Colors.blue,
//                                         decoration: TextDecoration.underline)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _launchURL(String url) async {
//     Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       print("Could not open $url");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error opening link")));
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> foodList = [];
  Map<String, dynamic>? selectedFood;

  @override
  void initState() {
    super.initState();
    _fetchFoodData();
  }

  Future<void> _fetchFoodData() async {
    final response =
        await http.get(Uri.parse("https://api.npoint.io/6077926ba47ea13a6372"));
    if (response.statusCode == 200) {
      setState(() {
        foodList = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print("Error fetching data: ${response.statusCode}");
    }
  }

  void _showFoodDetails(Map<String, dynamic> food) {
    setState(() {
      selectedFood = food;
    });
  }

  // Widget _buildSuggestionChip(String label) {
  //   return ActionChip(
  //     label: Text(label),
  //     onPressed: () {
  //       try {
  //         _showFoodDetails(foodList.firstWhere(
  //             (food) => food['food_name'].toString().toLowerCase() == label.toLowerCase()));
  //       } catch (e) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text("Oops! No matching food item found."),
  //           duration: Duration(seconds: 2),
  //         ));
  //       }
  //     },
  //     backgroundColor: Colors.teal.shade50,
  //     labelStyle: TextStyle(color: Colors.teal),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Food"), backgroundColor: Colors.teal),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) {
                final input = value.text.toLowerCase().trim();
                if (input.isEmpty) return const Iterable<String>.empty();

                return foodList
                    .map((food) => food['food_name'].toString())
                    .where((name) => name.toLowerCase().contains(input))
                    .toList();
              },
              onSelected: (String selection) {
                try {
                  final match = foodList.firstWhere(
                    (food) =>
                        food['food_name'].toString().toLowerCase().trim() ==
                        selection.toLowerCase().trim(),
                  );
                  _showFoodDetails(match);
                } catch (e) {
                  setState(() {
                    selectedFood = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Oops! No matching food item found."),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "Search food...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.search),
                  ),
                );
              },
            ),

            SizedBox(height: 16),

            // Show selected food details or awesome empty state
            selectedFood == null
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fastfood, size: 80, color: Colors.teal),
                        SizedBox(height: 16),
                        Text(
                          "Search for a food item",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Use the search bar above to view food details and nutrition.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 24),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            // _buildSuggestionChip("Apple"),
                            // _buildSuggestionChip("Paneer"),
                            // _buildSuggestionChip("Egg"),
                            // _buildSuggestionChip("Chicken Curry"),
                          ],
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedFood!['food_name'].toString(),
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Colors.teal,
                                ),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    selectedFood!['recipe']['image_url'],
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Cuisine: ${selectedFood!['recipe']['Cuisine']}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Georgia',
                                  color: Colors.teal.shade700,
                                ),
                              ),
                              SizedBox(height: 38),
                              Text(
                                "Ingredients:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Colors.teal.shade800,
                                ),
                              ),
                              Divider(
                                color: Colors.teal.shade300,
                                thickness: 1.5,
                              ),
                              ...selectedFood!['recipe']['ingredients']
                                  .split(',')
                                  .map((ingredient) => Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Text(
                                          "- $ingredient",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Arial',
                                            color: const Color.fromARGB(
                                                221, 55, 54, 54),
                                          ),
                                        ),
                                      )),
                              SizedBox(height: 38),
                              Text(
                                "Nutritional Values:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Colors.teal.shade800,
                                ),
                              ),
                              Divider(
                                color: Colors.teal.shade300,
                                thickness: 1.5,
                              ),
                              DataTable(
                                columns: [
                                  DataColumn(
                                      label: Text("Nutrient",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text("Amount")),
                                ],
                                rows: selectedFood!['nutritional_values']
                                    .entries
                                    .map<DataRow>((entry) => DataRow(cells: [
                                          DataCell(Text(entry.key.toString())),
                                          DataCell(
                                              Text(entry.value.toString())),
                                        ]))
                                    .toList(),
                              ),
                              SizedBox(height: 32),
                              Text(
                                "Instructions:",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Colors.teal.shade800,
                                ),
                              ),
                              Divider(
                                color: Colors.teal.shade300,
                                thickness: 1.5,
                              ),
                              SizedBox(height: 8),
                              ...selectedFood!['recipe']['instructions']
                                  .split('\n')
                                  .map((step) => Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.arrow_forward_ios,
                                                size: 14, color: Colors.teal),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(step,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Arial',
                                                    color: const Color.fromARGB(
                                                        221, 70, 70, 70),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      )),
                              Divider(),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () =>
                                    _launchURL(selectedFood!['recipe']['URL']),
                                child: Text(
                                  "View Full Recipe",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open $url");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error opening link")));
    }
  }
}
