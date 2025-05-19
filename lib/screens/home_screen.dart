import 'package:flutter/material.dart';
import '../widgets/food_card.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/nutrient_chart.dart';
import '../widgets/nutrient_bar_chart.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File; 
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _detections = [];
  File? _image;
  String? _processedImageBase64;
  int _selectedIndex = 0;
  bool _loading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage_without_crop(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _processedImageBase64 = null; 
      });
      _uploadImage(File(pickedFile.path)); 
    }
  }
Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressQuality: 80, // Adjust compression quality
        maxWidth: 1080, // Optional resizing
        maxHeight: 1080, // Optional resizing
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.teal,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false, // No fixed aspect ratio
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
        });
        _uploadImage(File(croppedFile.path));
      }
    }
  }

Future<void> _pickImage2(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPresetCustom(),
            ],
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
        });
        _uploadImage(File(croppedFile.path));
      }
    }
  }


  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _loading = true;
    });

    final uri = Uri.parse("http://192.168.0.104:5000/yolo_predict");

    final request = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath("image", imageFile.path));

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
print("Image picked: ${_image?.path}");
print("Processed image base64: $_processedImageBase64");
print("Detections: $_detections");
print("Loading: $_loading");
      if (response.statusCode == 200) {
        final decoded = json.decode(respStr);
        setState(() {
          _detections = decoded['detections'];
          _processedImageBase64 = decoded['image'];
        });
        print("Response: $decoded");
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



Future<void> _uploadImage2(File imageFile) async {
  setState(() {
    _loading = true;
  });

  
  // final uri = Uri.parse("https://cutiepi3-bhojan-ai.hf.space/yolo_predict");
  final uri = Uri.parse(
        "https://cutiepi3-bhojan-ai.hf.space/gradio_api/call/yolo_predict");

    final request = http.MultipartRequest("POST", uri)
      ..headers["Content-Type"] = "application/json"
      ..fields["data"] = jsonEncode([
        {
          "path": imageFile.path,
          "meta": {"_type": "gradio.FileData"}
        }
      ]);

  // final request = http.MultipartRequest("POST", uri)
  //   ..files.add(await http.MultipartFile.fromPath("file", imageFile.path));

    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    Map<String, dynamic> requestData = {
      "data": [
        {
          "path": base64Image,
          "meta": {"_type": "gradio.FileData"}
        }
      ]
    };

    try {
      final response = await http
          .post(
            uri,
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode(requestData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded.containsKey("event_id")) {
          String eventId = decoded["event_id"];
          print("Event ID: $eventId");

          var pollUrl = Uri.parse(
              "https://cutiepi3-bhojan-ai.hf.space/gradio_api/call/yolo_predict/$eventId");
          var pollResponse = await http.get(pollUrl);
          print("Raw API Response: ${pollResponse.body}");


          if (pollResponse.statusCode == 200) {
            var resultData = jsonDecode(pollResponse.body);

            setState(() {
              _detections = resultData["detections"];
              _processedImageBase64 = resultData["image"];
            });
          } else {
            print("Error polling result: ${pollResponse.statusCode}");
          }
        } else {
          print("Error: No event ID received.");
        }
      } else {
        print("Gradio API error (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      print("Upload failed: $e");
    }

  setState(() {
    _loading = false;
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bhojan AI"), backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _selectedIndex == 0
                ? Column(
                    children: [
                      (_image != null || _processedImageBase64 != null)
                          ? SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: PageView(
                                children: [
                                  if (_image != null)
                                    InteractiveViewer(
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ),
                                    ),
                                  if (_processedImageBase64 != null)
                                    InteractiveViewer(
                                      child: Image.memory(
                                        base64Decode(_processedImageBase64!
                                            .split(',')
                                            .last),
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                      ),
                                    ),
                                ],
                              ),

                             
                            )
                          :

                          Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.teal.shade50,
                                gradient: LinearGradient(
                                  colors: [Colors.teal.shade100, Colors.white],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Tip: Upload high-quality images for best results!",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),

                      SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: Icon(Icons.camera_alt),
                            label: Text("Camera"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: Icon(Icons.image),
                            label: Text("Gallery"),
                          ),
                        ],
                      ),

                      SizedBox(height: 46),

                      _loading
                          ? Center(child: CircularProgressIndicator())
                          :  (_image == null && _processedImageBase64 == null)?
          
                      Card(
                        color: Colors.orange.shade50,
                        borderOnForeground: true,
                        shadowColor: Colors.teal.shade100,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tips for better detection:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 6),
                            
                              
                              Text("• Use good lighting",style: TextStyle(fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 103, 102, 100)),),
                              Text("• Keep food in focus",
                                  style: TextStyle(fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 103, 102, 100)),),
                              Text("• Avoid busy backgrounds",
                                  style: TextStyle(fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 103, 102, 100)),),
                          
                              Text("• Avoid reflections",
                                  style: TextStyle(fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 103, 102, 100)),),
                            ],
                          ),
                        ),
                      )
                      :
                          _detections.isEmpty
                              ? 
                               Column(
                                      children: [
                                        Text("No food detected!",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        Text(
                                            "Try retaking the photo or choose a clearer one."),
                                        SizedBox(height: 12),
                                        ElevatedButton.icon(
                                          onPressed: () =>
                                              _pickImage(ImageSource.camera),
                                          icon: Icon(Icons.refresh),
                                          label: Text("Try Again"),
                                        ),
                                      ],
                                    )
                              : Column(
                                  
                                  children: _detections
                                      .map((det) => FoodCard(det))
                                      .toList(),
                                ),
                                
                    ],
                  )
                : Column(
                    children: [
                      Text("Nutrition Breakdown",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      _detections.isEmpty
                          ? Center(child: Text("No nutrition data available"))
                          : Column(
                              children: [
                                NutrientChart(
                                    _detections[0]['nutritional_info']),
                                SizedBox(height: 66),
                                NutrientBarChart(
                                    _detections[0]['nutritional_info']),
                              ],
                            ),
                    ],
                  ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "Detection"),
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart), label: "Nutrition"),
        ],
      ),
    );
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
