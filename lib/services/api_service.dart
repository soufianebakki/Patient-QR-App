import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // For Android emulator

  // For iOS simulator: 'http://localhost:5000/api'
  // For physical device: 'http://<your-computer-ip>:5000/api'

  static const String _baseUrl = 'http://10.0.2.2:5000/api'; // Android emulator

  static Future<Map<String, dynamic>> createPatient(
    Map<String, dynamic> data,
  ) async {
    try {
      print('Sending: ${jsonEncode(data)}');

      final response = await http
          .post(
            Uri.parse('$_baseUrl/patients'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Failed to connect. Please check:');
    }
  }
}
