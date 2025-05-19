import 'package:flutter/material.dart';
import 'package:protifeast/screens/bhojan_web_screen.dart';
import 'package:protifeast/screens/chatbot_screen.dart';
import 'package:protifeast/screens/favorites_screen.dart';
import 'package:protifeast/screens/home_screen.dart';
import 'package:protifeast/screens/my_plate_screen.dart';
import 'package:protifeast/screens/search_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PreHomeScreen extends StatefulWidget {
  const PreHomeScreen({super.key});

  @override
  _PreHomeScreenState createState() => _PreHomeScreenState();
}

class _PreHomeScreenState extends State<PreHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bhojan-Ai"),
        backgroundColor: Colors.teal,
      ),
     
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
           
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://i.imgur.com/DflZO3c.jpeg', 
                    ),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Diwakar Allu',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'allu.3435@gmail.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PreHomeScreen()));
                });
               
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Protifeast v1.0")),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Favorites"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoritesScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("Search Food"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("Chatbot"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatbotScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: Text("Bhojan AI Web"),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse('https://cutiepi3-bhojan-ai.hf.space/?__theme=system');

                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),

          ],
        ),
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              shadowColor: Colors.teal.withOpacity(0.5),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.teal[200]!, Colors.teal[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to Bhojan-AI!",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial',
                            color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Discover nutritional facts effortlessly.",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Search Nutrients in Food",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _searchOptions.length,
                      itemBuilder: (context, index) {
                        var item = _searchOptions[index];
                        return GestureDetector(
                          onTap: () => item["action"](context),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item["icon"],
                                      size: 40, color: Colors.teal),
                                  SizedBox(height: 10),
                                  Text(
                                    item["title"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 6),
                                  Expanded(
                                    child: Text(
                                      item["description"],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700]),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 50),

            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.teal.withOpacity(0.4),
              child: Container(
                width: double.infinity, 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 144, 231, 223),
                      const Color.fromARGB(255, 187, 227, 222)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://i.ibb.co/FL74NZfw/plate-for-the-day-f.png", 
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Plate for the Day",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            "A balanced plate for better nutrition",
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 93, 92, 92)
                                  .withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 45),

            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPlateScreen()));
                },
                child: RotationTransition(
                  turns: _controller,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      "https://i.ibb.co/FL74NZfw/plate-for-the-day-f.png",
                      width: 350,
                      height: 350,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
           
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _searchOptions = [
    {
      "title": "Search by Image",
      "icon": Icons.camera_alt,
      "description": "Scan food using your camera",
      "action": (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    },
    {
      "title": "Type Food Name",
      "icon": Icons.search,
      "description": "Manually enter a food name",
      "action": (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchScreen()));
      }
    },
  ];
}
