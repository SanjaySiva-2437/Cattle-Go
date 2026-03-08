import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutter_gen/gen_l10n/app_localizations.dart';

String lookupLocalization(AppLocalizations localizations, String key) {
  switch (key) {
    case 'girName':
      return localizations.girName;
    case 'girOrigin':
      return localizations.girOrigin;
    case 'girTrait':
      return localizations.girTrait;
    case 'girTraitShort':
      return localizations.girTraitShort;
    case 'girYield':
      return localizations.girYield;
    case 'girValue':
      return localizations.girValue;
    case 'girDescription':
      return localizations.girDescription;

    case 'sahiwalName':
      return localizations.sahiwalName;
    case 'sahiwalOrigin':
      return localizations.sahiwalOrigin;
    case 'sahiwalTrait':
      return localizations.sahiwalTrait;
    case 'sahiwalTraitShort':
      return localizations.sahiwalTraitShort;
    case 'sahiwalYield':
      return localizations.sahiwalYield;
    case 'sahiwalValue':
      return localizations.sahiwalValue;
    case 'sahiwalDescription':
      return localizations.sahiwalDescription;

    case 'murrahName':
      return localizations.murrahName;
    case 'murrahOrigin':
      return localizations.murrahOrigin;
    case 'murrahTrait':
      return localizations.murrahTrait;
    case 'murrahTraitShort':
      return localizations.murrahTraitShort;
    case 'murrahYield':
      return localizations.murrahYield;
    case 'murrahValue':
      return localizations.murrahValue;
    case 'murrahDescription':
      return localizations.murrahDescription;

    default:
      return key;
  }
}

class BreedDetailPage extends StatelessWidget {
  const BreedDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final breedData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final localizations = AppLocalizations.of(context)!;
    final Color deepGreen = Theme.of(context).colorScheme.secondary;

    final String name =
        lookupLocalization(localizations, breedData['nameKey']!);
    final String origin =
        lookupLocalization(localizations, breedData['originKey']!);
    final String trait =
        lookupLocalization(localizations, breedData['traitKey']!);
    final String yield =
        lookupLocalization(localizations, breedData['yieldKey']!);
    final String value =
        lookupLocalization(localizations, breedData['valueKey']!);
    final String description =
        lookupLocalization(localizations, breedData['descriptionKey']!);
    final String modelSrc = breedData['model_src']!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(name),
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ModelViewer(
                  src: modelSrc,
                  autoRotate: true,
                  cameraControls: true,
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 24),
              Text(name,
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: deepGreen)),
              Text(origin,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 24),
              Text(description,
                  style: GoogleFonts.poppins(
                      fontSize: 15, height: 1.6, color: Colors.grey.shade800)),
              const Divider(height: 40),
              _buildDetailRow(
                  Icons.star_outline, localizations.keyTrait, trait, deepGreen),
              _buildDetailRow(Icons.opacity_outlined, localizations.milkYield,
                  yield, deepGreen),
              _buildDetailRow(Icons.attach_money, localizations.marketValue,
                  value, deepGreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String title, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey.shade600)),
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
