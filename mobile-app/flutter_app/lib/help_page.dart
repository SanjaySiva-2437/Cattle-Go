import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutter_gen/gen_l10n/app_localizations.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(localizations.helpSupport),
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Frequently Asked Questions",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: deepGreen,
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              context,
              "How does the cattle classification work?",
              "Our app uses a powerful Machine Learning model. Simply upload or take a clear photo of the animal, and the model will analyze its features to predict the breed and detect potential health issues.",
            ),
            _buildFaqItem(
              context,
              "Is my data and are my photos secure?",
              "Yes. We prioritize your privacy. Photos are sent securely to our analysis server and are not shared with third parties. Please see our Privacy Policy for more details.",
            ),
            _buildFaqItem(
              context,
              "How accurate is the AI model?",
              "During development, this model demonstrated approximately 85% accuracy on its validation dataset. It is crucial to understand that real-world conditions can vary. Therefore, the output is a decision-support tool meant to aid—not replace—the expert judgment of a veterinary professional, who should make the final diagnosis.",
            ),
            const Divider(height: 40),
            Text(
              "Contact Us",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: deepGreen,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context,
              Icons.email_outlined,
              "Support Email",
              "sanjayksk1712@gmail.com",
            ),
            _buildContactItem(
              context,
              Icons.phone_outlined,
              "Support Hotline",
              "+91 94870 44111",
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "App Version 1.0.0 ",
                style: GoogleFonts.poppins(color: Colors.grey.shade500),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper widget for FAQ items
  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style:
                GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  // Helper widget for contact items
  Widget _buildContactItem(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        title: Text(title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins()),
      ),
    );
  }
}
