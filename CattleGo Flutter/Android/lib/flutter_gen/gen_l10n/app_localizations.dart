import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ta')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CattleGo'**
  String get appName;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}'**
  String welcomeGreeting(Object userName);

  /// No description provided for @analyzeHerd.
  ///
  /// In en, this message translates to:
  /// **'Analyze Your Herd'**
  String get analyzeHerd;

  /// No description provided for @logInButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logInButton;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @accountProfile.
  ///
  /// In en, this message translates to:
  /// **'Account & Profile'**
  String get accountProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @spotlightHeader.
  ///
  /// In en, this message translates to:
  /// **'3D Breed Spotlight'**
  String get spotlightHeader;

  /// No description provided for @traitsHeader.
  ///
  /// In en, this message translates to:
  /// **'Key Breeds & Traits'**
  String get traitsHeader;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @manageDetails.
  ///
  /// In en, this message translates to:
  /// **'Manage your subscription and details'**
  String get manageDetails;

  /// No description provided for @modelInfo.
  ///
  /// In en, this message translates to:
  /// **'Model & Data Information'**
  String get modelInfo;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @keyTrait.
  ///
  /// In en, this message translates to:
  /// **'Key Trait'**
  String get keyTrait;

  /// No description provided for @milkYield.
  ///
  /// In en, this message translates to:
  /// **'Milk Yield'**
  String get milkYield;

  /// No description provided for @marketValue.
  ///
  /// In en, this message translates to:
  /// **'Market Value'**
  String get marketValue;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Detailed Data'**
  String get viewDetails;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @classify.
  ///
  /// In en, this message translates to:
  /// **'Classify'**
  String get classify;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get records;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @captureLiveImage.
  ///
  /// In en, this message translates to:
  /// **'Capture Live Image'**
  String get captureLiveImage;

  /// No description provided for @useAIModel.
  ///
  /// In en, this message translates to:
  /// **'Use our powerful AI model to analyze your cattle.'**
  String get useAIModel;

  /// No description provided for @chatSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat Support'**
  String get chatSupport;

  /// No description provided for @galleryButton.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryButton;

  /// No description provided for @cameraButton.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraButton;

  /// No description provided for @howToButton.
  ///
  /// In en, this message translates to:
  /// **'How-To'**
  String get howToButton;

  /// No description provided for @modelInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View ML model version and accuracy data'**
  String get modelInfoSubtitle;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @helpSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs, documentation, and contact'**
  String get helpSupportSubtitle;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @emailReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Email (Read-Only)'**
  String get emailReadOnly;

  /// No description provided for @newDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'New Display Name'**
  String get newDisplayNameHint;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @oldPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPasswordHint;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'New Password (min 6 chars)'**
  String get newPasswordHint;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordButton;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @helpFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get helpFaqTitle;

  /// No description provided for @helpFaq1Question.
  ///
  /// In en, this message translates to:
  /// **'How does the cattle classification work?'**
  String get helpFaq1Question;

  /// No description provided for @helpFaq1Answer.
  ///
  /// In en, this message translates to:
  /// **'Our app uses a powerful Machine Learning model. Simply upload or take a clear photo of the animal, and the model will analyze its features to predict the breed and detect potential health issues.'**
  String get helpFaq1Answer;

  /// No description provided for @helpFaq2Question.
  ///
  /// In en, this message translates to:
  /// **'Is my data and are my photos secure?'**
  String get helpFaq2Question;

  /// No description provided for @helpFaq2Answer.
  ///
  /// In en, this message translates to:
  /// **'Yes. We prioritize your privacy. Photos are sent securely to our analysis server and are not shared with third parties. Please see our Privacy Policy for more details.'**
  String get helpFaq2Answer;

  /// No description provided for @helpFaq3Question.
  ///
  /// In en, this message translates to:
  /// **'How accurate is the AI model?'**
  String get helpFaq3Question;

  /// No description provided for @helpFaq3Answer.
  ///
  /// In en, this message translates to:
  /// **'Our model is trained on a vast dataset of cattle images for high accuracy. However, results should be considered a preliminary guide and not a substitute for professional veterinary advice.'**
  String get helpFaq3Answer;

  /// No description provided for @helpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get helpContactTitle;

  /// No description provided for @helpContactEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Support Email'**
  String get helpContactEmailTitle;

  /// No description provided for @helpContactEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'support@cattle-intelligence.com'**
  String get helpContactEmailAddress;

  /// No description provided for @helpContactPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Support Hotline'**
  String get helpContactPhoneTitle;

  /// No description provided for @helpContactPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'+91-123-456-7890'**
  String get helpContactPhoneNumber;

  /// No description provided for @helpAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version 1.0.0 (Hackathon Build)'**
  String get helpAppVersion;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy for Cattle Intelligence'**
  String get privacyTitle;

  /// No description provided for @privacyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: October 4, 2025'**
  String get privacyLastUpdated;

  /// No description provided for @privacySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Content.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly to us, such as your name and email when you create an account. We also process the images you upload for the purpose of AI analysis. We use Firebase Authentication for user management.'**
  String get privacySection1Content;

  /// No description provided for @privacySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Content.
  ///
  /// In en, this message translates to:
  /// **'The images you provide are sent to our secure server for analysis by our machine learning model. The results are sent back to your device. We do not use your images for any other purpose without your explicit consent.'**
  String get privacySection2Content;

  /// No description provided for @privacySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Data Security'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Content.
  ///
  /// In en, this message translates to:
  /// **'We implement reasonable security measures to protect your data from unauthorized access. However, no electronic transmission or storage is 100% secure.'**
  String get privacySection3Content;

  /// No description provided for @privacySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Third-Party Services'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Content.
  ///
  /// In en, this message translates to:
  /// **'This app uses third-party services like Firebase for authentication and cloud services for model hosting. These services have their own privacy policies.'**
  String get privacySection4Content;

  /// No description provided for @privacySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Contact Us'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Content.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us at privacy@cattle-intelligence.com.'**
  String get privacySection5Content;

  /// No description provided for @privacyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer: This is a template privacy policy for a hackathon project and is not legally binding advice.'**
  String get privacyDisclaimer;

  /// No description provided for @howToTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Use the App'**
  String get howToTitle;

  /// No description provided for @howToStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Capture or Select an Image'**
  String get howToStep1Title;

  /// No description provided for @howToStep1Content.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'Gallery\' or \'Camera\' buttons on the home screen or the classification page. Choose a clear, side-view photo of the cattle for the best results.'**
  String get howToStep1Content;

  /// No description provided for @howToStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Analyze the Image'**
  String get howToStep2Title;

  /// No description provided for @howToStep2Content.
  ///
  /// In en, this message translates to:
  /// **'Once you select an image, our AI model will automatically start analyzing its features, patterns, and physical traits to identify the breed and check for health indicators.'**
  String get howToStep2Content;

  /// No description provided for @howToStep3Title.
  ///
  /// In en, this message translates to:
  /// **'View the Results'**
  String get howToStep3Title;

  /// No description provided for @howToStep3Content.
  ///
  /// In en, this message translates to:
  /// **'After a few moments, you will receive a detailed analysis, including the predicted cattle breed, its key traits, estimated milk yield, and market value.'**
  String get howToStep3Content;

  /// No description provided for @howToStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Ask the AI Assistant'**
  String get howToStep4Title;

  /// No description provided for @howToStep4Content.
  ///
  /// In en, this message translates to:
  /// **'If you have more questions about a specific breed, diseases, or cattle management, tap the \'Chat Support\' button to talk with our knowledgeable AI assistant.'**
  String get howToStep4Content;

  /// No description provided for @girName.
  ///
  /// In en, this message translates to:
  /// **'Gir Cow'**
  String get girName;

  /// No description provided for @girOrigin.
  ///
  /// In en, this message translates to:
  /// **'Gujarat, India'**
  String get girOrigin;

  /// No description provided for @girTrait.
  ///
  /// In en, this message translates to:
  /// **'A2 Milk, Heat Tolerant'**
  String get girTrait;

  /// No description provided for @girTraitShort.
  ///
  /// In en, this message translates to:
  /// **'A2 Milk & Hardy'**
  String get girTraitShort;

  /// No description provided for @girYield.
  ///
  /// In en, this message translates to:
  /// **'1500-2000 L/year'**
  String get girYield;

  /// No description provided for @girValue.
  ///
  /// In en, this message translates to:
  /// **'High Demand'**
  String get girValue;

  /// No description provided for @girDescription.
  ///
  /// In en, this message translates to:
  /// **'The Gir is one of the principal Zebu breeds originating in India. It is famous for its milk production and resistance to hot temperatures and tropical diseases. Its unique appearance includes a rounded and domed forehead and long, pendulous ears.'**
  String get girDescription;

  /// No description provided for @sahiwalName.
  ///
  /// In en, this message translates to:
  /// **'Sahiwal'**
  String get sahiwalName;

  /// No description provided for @sahiwalOrigin.
  ///
  /// In en, this message translates to:
  /// **'Punjab, India/Pakistan'**
  String get sahiwalOrigin;

  /// No description provided for @sahiwalTrait.
  ///
  /// In en, this message translates to:
  /// **'High Milk Yield, Docile Nature'**
  String get sahiwalTrait;

  /// No description provided for @sahiwalTraitShort.
  ///
  /// In en, this message translates to:
  /// **'High Milk Yield'**
  String get sahiwalTraitShort;

  /// No description provided for @sahiwalYield.
  ///
  /// In en, this message translates to:
  /// **'2000-2500 L/year'**
  String get sahiwalYield;

  /// No description provided for @sahiwalValue.
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get sahiwalValue;

  /// No description provided for @sahiwalDescription.
  ///
  /// In en, this message translates to:
  /// **'The Sahiwal is a breed of zebu cow, named after the Sahiwal district of Punjab, Pakistan. It is considered one of the best dairy breeds in the region due to its high milk production and the ability to sire small, fast-growing calves. It is known for its reddish-brown color and docile temperament.'**
  String get sahiwalDescription;

  /// No description provided for @murrahName.
  ///
  /// In en, this message translates to:
  /// **'Murrah Buffalo'**
  String get murrahName;

  /// No description provided for @murrahOrigin.
  ///
  /// In en, this message translates to:
  /// **'Haryana, India'**
  String get murrahOrigin;

  /// No description provided for @murrahTrait.
  ///
  /// In en, this message translates to:
  /// **'Highest Milk Fat Content'**
  String get murrahTrait;

  /// No description provided for @murrahTraitShort.
  ///
  /// In en, this message translates to:
  /// **'High Fat Milk'**
  String get murrahTraitShort;

  /// No description provided for @murrahYield.
  ///
  /// In en, this message translates to:
  /// **'1800-2500 L/year'**
  String get murrahYield;

  /// No description provided for @murrahValue.
  ///
  /// In en, this message translates to:
  /// **'Elite Dairy Animal'**
  String get murrahValue;

  /// No description provided for @murrahDescription.
  ///
  /// In en, this message translates to:
  /// **'The Murrah buffalo is a breed of water buffalo mainly found in the Indian states of Haryana and Punjab. It is kept for dairy production and is often called the \'black gold\' of India. Its milk has a very high fat content, making it excellent for producing premium dairy products like ghee and butter.'**
  String get murrahDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
