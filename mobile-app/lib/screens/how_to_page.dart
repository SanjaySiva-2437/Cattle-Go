import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutter_gen/gen_l10n/app_localizations.dart';

class HowToPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(localizations.howToTitle),
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Stepper(
          // This makes the stepper a static display, not for user input
          currentStep: 0,
          controlsBuilder: (context, details) => Container(),
          steps: [
            Step(
              title: Text(localizations.howToStep1Title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              content: Text(localizations.howToStep1Content,
                  style: GoogleFonts.poppins()),
              isActive: true,
            ),
            Step(
              title: Text(localizations.howToStep2Title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              content: Text(localizations.howToStep2Content,
                  style: GoogleFonts.poppins()),
              isActive: true,
            ),
            Step(
              title: Text(localizations.howToStep3Title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              content: Text(localizations.howToStep3Content,
                  style: GoogleFonts.poppins()),
              isActive: true,
            ),
            Step(
              title: Text(localizations.howToStep4Title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              content: Text(localizations.howToStep4Content,
                  style: GoogleFonts.poppins()),
              isActive: true,
            ),
          ],
        ),
      ),
    );
  }
}
