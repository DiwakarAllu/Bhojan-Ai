import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<dynamic>> fetchDetections() async {
    final uri = Uri.parse("http://192.168.0.101:5000/prediction");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['detections'];
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("API error: $e");
      return [];
    }
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = "http://127.0.0.1:5000"; // Replace this

//   static Future<List<dynamic>> predictImage(File imageFile) async {
//     var request = http.MultipartRequest("POST", Uri.parse('$baseUrl/prediction'));
//     request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

//     var response = await request.send();
//     if (response.statusCode == 200) {
//       var respStr = await response.stream.bytesToString();
//       var data = jsonDecode(respStr);
//       return data['detections'];
//     } else {
//       print("Error: ${response.statusCode}");
//       return [];
//     }
//   }
// }
