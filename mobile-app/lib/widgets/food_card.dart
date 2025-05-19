import 'package:flutter/material.dart';
import 'package:protifeast/services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:protifeast/widgets/nutrition_info_card.dart'; 

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> det;

  const FoodCard(this.det, {super.key});

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = det?['nutritional_info']?? {};
    if (info.isEmpty) {
      return Center(child: Text("No nutritional information available."));
    }
    

    return Column(
      children: [
        Card(
          elevation: 6,
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Row(
                  children: [
                    Text(
                      info['name'],
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: () async {
                        await StorageService.saveFavorite(det);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${info['name']} added to favorites!"),
                        ));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),

            
                Text(
                  "A delicious dish made with the following ingredients:",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 12),

              
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: info['ingredients']
                      .map<Widget>((ingredient) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 8, color: Colors.teal),
                                SizedBox(width: 8),
                                Text(ingredient,
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: 12),

                
                GestureDetector(
                  onTap: () => _launchURL(info['source_url']),
                  child: Text(
                    "More info",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),

        
        NutritionInfoCard(nutritionData: info),
        
        
      ],
    );
  }
}

