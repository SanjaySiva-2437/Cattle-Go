// lib/services/classification_service.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // TimeoutException

class ClassificationService {
  // URL of your FastAPI endpoint
  static const String _uploadUrl =
      'https://superstrenuous-marcelina-overeffusively.ngrok-free.dev/predict';

  /// Uploads an image and returns the classification results
  /// formatted like Python's `generate_text_response`
  Future<Map<String, dynamic>> classifyImage(File imageFile) async {
    final uri = Uri.parse(_uploadUrl);
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // must match backend
        imageFile.path,
      ),
    );

    try {
      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 90));

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _formatOutput(data); // format the JSON for Flutter
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('The request timed out. Please try again.');
    } catch (e) {
      print('Error in classifyImage: $e');
      throw Exception(
          'Failed to connect to the server. Check your internet connection.');
    }
  }

  /// Formats the raw server response into Flutter-friendly keys
  Map<String, dynamic> _formatOutput(Map<String, dynamic> data) {
    String breedName = data['class'] ?? 'Unknown';
    double confidence = (data['confidence'] ?? 0.0).toDouble();
    String description = data['description'] ?? '';
    String serverMessage = data['message'] ?? '';

    // Confidence text like Python function
    String confidenceText;
    double confidencePercent = confidence * 100;
    if (confidence > 0.85) {
      confidenceText =
          'I am highly confident (${confidencePercent.toStringAsFixed(2)}%)';
    } else if (confidence > 0.6) {
      confidenceText =
          'I am fairly confident (${confidencePercent.toStringAsFixed(2)}%)';
    } else {
      confidenceText =
          'The prediction is uncertain (${confidencePercent.toStringAsFixed(2)}%)';
    }

    return {
      'breedName': breedName,
      'confidenceText': confidenceText,
      'description': description,
      'serverMessage': serverMessage,
    };
  }

  /// Optional helper to get a single formatted string for UI display
  String formattedMessage(Map<String, dynamic> prediction) {
    return '''
Breed Name: ${prediction['breedName']}
Confidence: ${prediction['confidenceText']}

Description:
${prediction['description']}

Server Message:
${prediction['serverMessage']}
''';
  }
}
