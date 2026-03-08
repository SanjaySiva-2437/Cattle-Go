// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CattleGo';

  @override
  String welcomeGreeting(Object userName) {
    return 'Welcome, $userName';
  }

  @override
  String get analyzeHerd => 'Analyze Your Herd';

  @override
  String get logInButton => 'Log In';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get accountProfile => 'Account & Profile';

  @override
  String get language => 'Language';

  @override
  String get spotlightHeader => '3D Breed Spotlight';

  @override
  String get traitsHeader => 'Key Breeds & Traits';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get manageDetails => 'Manage your subscription and details';

  @override
  String get modelInfo => 'Model & Data Information';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get changePassword => 'Change Password';

  @override
  String get keyTrait => 'Key Trait';

  @override
  String get milkYield => 'Milk Yield';

  @override
  String get marketValue => 'Market Value';

  @override
  String get viewDetails => 'View Detailed Data';

  @override
  String get home => 'Home';

  @override
  String get classify => 'Classify';

  @override
  String get records => 'Records';

  @override
  String get selectFromGallery => 'Select from Gallery';

  @override
  String get captureLiveImage => 'Capture Live Image';

  @override
  String get useAIModel => 'Use our powerful AI model to analyze your cattle.';

  @override
  String get chatSupport => 'Chat Support';

  @override
  String get galleryButton => 'Gallery';

  @override
  String get cameraButton => 'Camera';

  @override
  String get howToButton => 'How-To';

  @override
  String get modelInfoSubtitle => 'View ML model version and accuracy data';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get helpSupportSubtitle => 'FAQs, documentation, and contact';

  @override
  String get personalDetails => 'Personal Details';

  @override
  String get displayName => 'Display Name';

  @override
  String get emailReadOnly => 'Email (Read-Only)';

  @override
  String get newDisplayNameHint => 'New Display Name';

  @override
  String get security => 'Security';

  @override
  String get oldPasswordHint => 'Old Password';

  @override
  String get newPasswordHint => 'New Password (min 6 chars)';

  @override
  String get changePasswordButton => 'Change Password';

  @override
  String get origin => 'Origin';

  @override
  String get helpFaqTitle => 'Frequently Asked Questions';

  @override
  String get helpFaq1Question => 'How does the cattle classification work?';

  @override
  String get helpFaq1Answer => 'Our app uses a powerful Machine Learning model. Simply upload or take a clear photo of the animal, and the model will analyze its features to predict the breed and detect potential health issues.';

  @override
  String get helpFaq2Question => 'Is my data and are my photos secure?';

  @override
  String get helpFaq2Answer => 'Yes. We prioritize your privacy. Photos are sent securely to our analysis server and are not shared with third parties. Please see our Privacy Policy for more details.';

  @override
  String get helpFaq3Question => 'How accurate is the AI model?';

  @override
  String get helpFaq3Answer => 'Our model is trained on a vast dataset of cattle images for high accuracy. However, results should be considered a preliminary guide and not a substitute for professional veterinary advice.';

  @override
  String get helpContactTitle => 'Contact Us';

  @override
  String get helpContactEmailTitle => 'Support Email';

  @override
  String get helpContactEmailAddress => 'support@cattle-intelligence.com';

  @override
  String get helpContactPhoneTitle => 'Support Hotline';

  @override
  String get helpContactPhoneNumber => '+91-123-456-7890';

  @override
  String get helpAppVersion => 'App Version 1.0.0 (Hackathon Build)';

  @override
  String get privacyTitle => 'Privacy Policy for Cattle Intelligence';

  @override
  String get privacyLastUpdated => 'Last updated: October 4, 2025';

  @override
  String get privacySection1Title => '1. Information We Collect';

  @override
  String get privacySection1Content => 'We collect information you provide directly to us, such as your name and email when you create an account. We also process the images you upload for the purpose of AI analysis. We use Firebase Authentication for user management.';

  @override
  String get privacySection2Title => '2. How We Use Your Information';

  @override
  String get privacySection2Content => 'The images you provide are sent to our secure server for analysis by our machine learning model. The results are sent back to your device. We do not use your images for any other purpose without your explicit consent.';

  @override
  String get privacySection3Title => '3. Data Security';

  @override
  String get privacySection3Content => 'We implement reasonable security measures to protect your data from unauthorized access. However, no electronic transmission or storage is 100% secure.';

  @override
  String get privacySection4Title => '4. Third-Party Services';

  @override
  String get privacySection4Content => 'This app uses third-party services like Firebase for authentication and cloud services for model hosting. These services have their own privacy policies.';

  @override
  String get privacySection5Title => '5. Contact Us';

  @override
  String get privacySection5Content => 'If you have any questions about this Privacy Policy, please contact us at privacy@cattle-intelligence.com.';

  @override
  String get privacyDisclaimer => 'Disclaimer: This is a template privacy policy for a hackathon project and is not legally binding advice.';

  @override
  String get howToTitle => 'How to Use the App';

  @override
  String get howToStep1Title => 'Capture or Select an Image';

  @override
  String get howToStep1Content => 'Tap the \'Gallery\' or \'Camera\' buttons on the home screen or the classification page. Choose a clear, side-view photo of the cattle for the best results.';

  @override
  String get howToStep2Title => 'Analyze the Image';

  @override
  String get howToStep2Content => 'Once you select an image, our AI model will automatically start analyzing its features, patterns, and physical traits to identify the breed and check for health indicators.';

  @override
  String get howToStep3Title => 'View the Results';

  @override
  String get howToStep3Content => 'After a few moments, you will receive a detailed analysis, including the predicted cattle breed, its key traits, estimated milk yield, and market value.';

  @override
  String get howToStep4Title => 'Ask the AI Assistant';

  @override
  String get howToStep4Content => 'If you have more questions about a specific breed, diseases, or cattle management, tap the \'Chat Support\' button to talk with our knowledgeable AI assistant.';

  @override
  String get girName => 'Gir Cow';

  @override
  String get girOrigin => 'Gujarat, India';

  @override
  String get girTrait => 'A2 Milk, Heat Tolerant';

  @override
  String get girTraitShort => 'A2 Milk & Hardy';

  @override
  String get girYield => '1500-2000 L/year';

  @override
  String get girValue => 'High Demand';

  @override
  String get girDescription => 'The Gir is one of the principal Zebu breeds originating in India. It is famous for its milk production and resistance to hot temperatures and tropical diseases. Its unique appearance includes a rounded and domed forehead and long, pendulous ears.';

  @override
  String get sahiwalName => 'Sahiwal';

  @override
  String get sahiwalOrigin => 'Punjab, India/Pakistan';

  @override
  String get sahiwalTrait => 'High Milk Yield, Docile Nature';

  @override
  String get sahiwalTraitShort => 'High Milk Yield';

  @override
  String get sahiwalYield => '2000-2500 L/year';

  @override
  String get sahiwalValue => 'Very High';

  @override
  String get sahiwalDescription => 'The Sahiwal is a breed of zebu cow, named after the Sahiwal district of Punjab, Pakistan. It is considered one of the best dairy breeds in the region due to its high milk production and the ability to sire small, fast-growing calves. It is known for its reddish-brown color and docile temperament.';

  @override
  String get murrahName => 'Murrah Buffalo';

  @override
  String get murrahOrigin => 'Haryana, India';

  @override
  String get murrahTrait => 'Highest Milk Fat Content';

  @override
  String get murrahTraitShort => 'High Fat Milk';

  @override
  String get murrahYield => '1800-2500 L/year';

  @override
  String get murrahValue => 'Elite Dairy Animal';

  @override
  String get murrahDescription => 'The Murrah buffalo is a breed of water buffalo mainly found in the Indian states of Haryana and Punjab. It is kept for dairy production and is often called the \'black gold\' of India. Its milk has a very high fat content, making it excellent for producing premium dairy products like ghee and butter.';
}
