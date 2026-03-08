import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(localizations.privacyPolicy),
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy for Cattle Intelligence",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Last updated: October 4, 2025",
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 20),
            _buildPolicySection(
              "1. Information We Collect",
              "We collect information you provide directly to us, such as your name and email when you create an account. We also process the images you upload for the purpose of AI analysis. We use Firebase Authentication for user management.",
            ),
            _buildPolicySection(
              "2. How We Use Your Information",
              "The images you provide are sent to our secure server for analysis by our machine learning model. The results are sent back to your device. We do not use your images for any other purpose without your explicit consent.",
            ),
            _buildPolicySection(
              "3. Data Security",
              "We implement reasonable security measures to protect your data from unauthorized access. However, no electronic transmission or storage is 100% secure.",
            ),
            _buildPolicySection(
              "4. Third-Party Services",
              "This app uses third-party services like Firebase for authentication and cloud services for model hosting. These services have their own privacy policies.",
            ),
            _buildPolicySection(
              "5. Contact Us",
              "If you have any questions about this Privacy Policy, please contact us at privacy@cattle-intelligence.com.",
            ),
            const SizedBox(height: 20),
            Text(
              "Disclaimer: This is a template privacy policy for a hackathon project and is not legally binding advice.",
              style: GoogleFonts.poppins(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade500,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for policy sections
  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.poppins(
                fontSize: 14, color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }
}
