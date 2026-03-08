// lib/services/classification_service.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ClassificationService {
  static const String _uploadUrl =
      'https://superstrenuous-marcelina-overeffusively.ngrok-free.dev/predict';

  Future<Map<String, dynamic>> classifyImage(File imageFile) async {
    print('🟡 DEBUG: Starting image classification...');
    print('🟡 DEBUG: Image path: ${imageFile.path}');

    final uri = Uri.parse(_uploadUrl);
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    try {
      print('🟡 DEBUG: Sending request to server...');
      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 90));

      final response = await http.Response.fromStream(streamedResponse);
      print('🟡 DEBUG: Response status: ${response.statusCode}');
      print('🟡 DEBUG: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print('🟢 DEBUG: Successfully parsed response');

        final formattedData = _formatOutput(data);
        print('🟢 DEBUG: Formatted data: $formattedData');

        return formattedData;
      } else {
        throw Exception(
            'Server error: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      throw Exception('The request timed out. Please try again.');
    } catch (e) {
      print('🔴 DEBUG: Error in classifyImage: $e');
      throw Exception(
          'Failed to connect to the server. Check your internet connection.');
    }
  }

  Map<String, dynamic> _formatOutput(Map<String, dynamic> data) {
    String breedName = data['class'] ?? 'Unknown';
    double confidence = (data['confidence'] ?? 0.0).toDouble();
    String description = data['description'] ?? '';
    String serverMessage = data['message'] ?? '';

    String confidenceText;
    double confidencePercent = confidence * 100;
    if (confidence > 0.85) {
      confidenceText =
          'Highly confident (${confidencePercent.toStringAsFixed(2)}%)';
    } else if (confidence > 0.6) {
      confidenceText =
          'Fairly confident (${confidencePercent.toStringAsFixed(2)}%)';
    } else {
      confidenceText = 'Uncertain (${confidencePercent.toStringAsFixed(2)}%)';
    }

    return {
      'breedName': breedName,
      'confidence': confidence,
      'confidenceText': confidenceText,
      'confidencePercent': confidencePercent,
      'description': description,
      'serverMessage': serverMessage,
      'rawData': data, // Keep original data for debugging
    };
  }

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
