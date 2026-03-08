// lib/result_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final File imageFile = arguments['image'];
    final Map<String, dynamic> results = arguments['results'];

    // 🔹 Extract values from results map
    final String breed = results['breedName'] ?? 'N/A';
    final String confidence = results['confidenceText'] ?? 'N/A';
    final String description = results['description'] ?? 'N/A';
    final String serverMessage = results['serverMessage'] ?? 'N/A';
    final bool hasError = results.containsKey('error');

    final Color deepGreen = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Analysis Result'),
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  imageFile,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Results',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold, color: deepGreen),
            ),
            const Divider(),
            const SizedBox(height: 16),
            if (hasError)
              _buildResultRow(Icons.error_outline, "Error", results['error'],
                  Colors.red.shade700)
            else ...[
              _buildResultRow(Icons.pets, "Predicted Breed", breed, deepGreen),
              _buildResultRow(
                  Icons.bar_chart, "Confidence", confidence, deepGreen),
              _buildResultRow(
                  Icons.info_outline, "Description", description, deepGreen),
              _buildResultRow(Icons.message_outlined, "Server Message",
                  serverMessage, deepGreen),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
      IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        color: Colors.grey.shade600, fontSize: 14)),
                Text(value,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 18)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
