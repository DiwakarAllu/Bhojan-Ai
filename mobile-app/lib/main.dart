// import 'package:flutter/material.dart';
// import 'package:protifeast/screens/home_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'BhojanAI-ProtiFeast',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const HomeScreen()
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:protifeast/screens/pre_home.dart';

void main() {
  runApp(MaterialApp(
    home: PreHomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}


/*
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: FoodDetectionPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class FoodDetectionPage extends StatefulWidget {
  @override
  _FoodDetectionPageState createState() => _FoodDetectionPageState();
}

class _FoodDetectionPageState extends State<FoodDetectionPage> {
  File? _image;
  bool _loading = false;
  List<dynamic> _detections = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _detections.clear();
      });
      _uploadImage(File(pickedFile.path));
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _loading = true;
    });

    final uri =
        Uri.parse("http://192.168.0.101:5000/prediction");

    final request = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath("image", imageFile.path));

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = json.decode(respStr);
        setState(() {
          _detections = decoded['detections'];
        });
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Upload error: $e");
    }

    setState(() {
      _loading = false;
    });
  }

  Widget _buildDetectionList() {
    if (_detections.isEmpty) {
      return Text("No detections yet.");
    }

    return Column(
      children: _detections.map((det) {
        final info = det['nutritional_info'];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(det['class']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Calories: ${info['calories']} kcal"),
                Text("Protein: ${info['protein']} g"),
                Text("Fat: ${info['fat']} g"),
                Text("Carbs: ${info['carbohydrate']} g"),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bhojan AI - Food Detection"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : Placeholder(fallbackHeight: 200),
            SizedBox(height: 16),
            _loading
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera),
                        label: Text("Camera"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.image),
                        label: Text("Gallery"),
                      ),
                    ],
                  ),
            SizedBox(height: 16),
            Expanded(child: SingleChildScrollView(child: _buildDetectionList()))
          ],
        ),
      ),
    );
  }
}
*/

