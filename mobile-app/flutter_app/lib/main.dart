import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// --- Core Networking Import ---
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// -----------------------------

// --- Localization Imports ---
import 'package:flutter_localizations/flutter_localizations.dart';
import 'flutter_gen/gen_l10n/app_localizations.dart';
// ----------------------------

// Import the necessary Firebase packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import the generated configuration file (ensure this file exists in lib/)
import 'firebase_options.dart';

// 🟢 Import new files for classification
import 'services/classification_service.dart';
import 'result_page.dart';
import 'realtime_camera_page.dart';
import 'help_page.dart';
import 'privacy_policy_page.dart';
import 'models/breed_model.dart';
import 'data/breed_data.dart';
import 'screens/breed_detail_screen.dart';
import 'screens/breed_list_screen.dart';

// --- CHAT MESSAGE MODEL ---
enum MessageSender { user, ai }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final bool isLoading;
  final bool isError;

  ChatMessage(
      {required this.text,
      required this.sender,
      this.isLoading = false,
      this.isError = false});
}
// --------------------------

// --- CHAT SERVICE: Handles communication with FastAPI ---
class ChatService {
  static const String _baseUrl =
      'https://stanford-undefensed-unspitefully.ngrok-free.dev';

  static const String _endpoint = '/chat';

  Future<String> askQuestion(String question) async {
    final uri = Uri.parse('$_baseUrl$_endpoint');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'query': question,
            }),
          )
          .timeout(const Duration(minutes: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data.containsKey('answer')) {
          return data['answer'] ?? 'Error: Empty answer field from API.';
        } else if (data.containsKey('error')) {
          return 'API Error: ${data['error']}';
        } else {
          return 'Error: API returned an unrecognized response format.';
        }
      } else {
        return 'Error: API returned status code ${response.statusCode}. Check server configuration.';
      }
    } on TimeoutException {
      return 'Error: Request timed out (4 minutes). The RAG model is taking too long to generate a response.';
    } catch (e) {
      print('Network/Serialization Error: $e');
      return 'Error: Could not connect to FastAPI server. Ensure your friend\'s server is running and accessible.';
    }
  }
}
// ----------------------------------------------------

// --- LANGUAGE MANAGEMENT SERVICE (Unchanged) ---
class ListenableProvider<T extends ChangeNotifier>
    extends InheritedNotifier<T> {
  const ListenableProvider({
    super.key,
    required T super.notifier,
    required super.child,
  });

  static T of<T extends ChangeNotifier>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ListenableProvider<T>>();
    if (provider == null) {
      throw FlutterError('No ListenableProvider found in context.');
    }
    return provider.notifier!;
  }
}

class LocaleManager extends ChangeNotifier {
  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  static final List<Locale> supportedLocales = [
    const Locale('en', ''),
    const Locale('hi', 'IN'),
    const Locale('ta', 'IN'),
  ];

  final Map<String, String> languageMap = {
    'en': 'English (US)',
    'hi': 'हिन्दी (Hindi)',
    'ta': 'தமிழ் (Tamil)',
  };

  void setLocale(String languageCode) {
    if (languageCode == 'en') {
      _locale = const Locale('en', '');
    } else if (languageCode == 'hi') {
      _locale = const Locale('hi', 'IN');
    } else if (languageCode == 'ta') {
      _locale = const Locale('ta', 'IN');
    }
    notifyListeners();
  }
}

class Consumer<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext context, T value) builder;

  const Consumer({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final notifier = ListenableProvider.of<T>(context);
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, child) => builder(context, notifier),
    );
  }
}
// --- END LANGUAGE MANAGEMENT SERVICE ---

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
    // You can show an error screen or use mock data
    // For now, we'll just continue but features requiring Firebase will fail gracefully
  }

  runApp(CattleApp());
}

// 🟢 DATA REFACTORED to use localization keys
final List<Map<String, String>> breedSpotlights = [
  {
    'nameKey': 'girName',
    'originKey': 'girOrigin',
    'traitKey': 'girTrait',
    'traitShortKey': 'girTraitShort',
    'yieldKey': 'girYield',
    'valueKey': 'girValue',
    'descriptionKey': 'girDescription',
    'model_src': 'assets/cow.glb'
  },
  {
    'nameKey': 'sahiwalName',
    'originKey': 'sahiwalOrigin',
    'traitKey': 'sahiwalTrait',
    'traitShortKey': 'sahiwalTraitShort',
    'yieldKey': 'sahiwalYield',
    'valueKey': 'sahiwalValue',
    'descriptionKey': 'sahiwalDescription',
    'model_src': 'assets/cow.glb'
  },
  {
    'nameKey': 'murrahName',
    'originKey': 'murrahOrigin',
    'traitKey': 'murrahTrait',
    'traitShortKey': 'murrahTraitShort',
    'yieldKey': 'murrahYield',
    'valueKey': 'murrahValue',
    'descriptionKey': 'murrahDescription',
    'model_src': 'assets/cow.glb'
  },
];

// 🟢 ADD lookupLocalization FUNCTION
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
      return key; // Fallback to the key name if not found
  }
}

// --- 1. Main App and Theme Setup ---
class CattleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<LocaleManager>(
      notifier: LocaleManager(),
      child: Consumer<LocaleManager>(
        builder: (context, localeManager) {
          return MaterialApp(
            title: 'Cattle Classifier',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF7F9FC),
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme.apply(
                      bodyColor: const Color(0xFF1E3A24),
                    ),
              ),
              primaryColor: const Color(0xFF4CAF50),
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.green,
              ).copyWith(secondary: const Color(0xFF1E7D2E)),
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
            ),
            locale: localeManager.locale,
            supportedLocales: LocaleManager.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: AuthWrapper(),
            routes: {
  '/classify': (context) => ClassificationPage(),
  '/settings': (context) => SettingsPage(),
  '/login': (context) => LoginPage(),
  '/signup': (context) => SignUpPage(),
  '/profile': (context) => AccountProfilePage(),
  '/language': (context) => LanguageSelectionPage(),
  '/chat': (context) => ChatScreen(),
  '/help': (context) => HelpAndSupportPage(),
  '/privacy': (context) => PrivacyPolicyPage(),
  '/howto': (context) => HowToPage(),
  // Remove the old breedDetail route to avoid confusion
  '/result': (context) => ResultPage(),
  '/realtime': (context) => RealtimeCameraPage(),
  // 🟢 UPDATED BREED ROUTES:
  '/breeds': (context) => BreedListScreen(),
  '/breedDetailNew': (context) {
    final breed =
        ModalRoute.of(context)!.settings.arguments as Breed;
    print('DEBUG: Loading breed detail for ${breed.name}');
    print('DEBUG: Image path: ${breed.imageUrl}');
    return BreedDetailScreen(breed: breed);
  },
  // 🟢 ADD THE OLD BREED DETAIL ROUTE THAT'S BEING REFERENCED:
  '/breedDetail': (context) {
    final breedData = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return BreedDetailPage();
  },
},
          );
        },
      ),
    );
  }
}

// --- 2. Auth Wrapper (Unchanged) ---
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return HomePage();
        }

        return LoginPage();
      },
    );
  }
}

// --- 3. Login Page UI (Unchanged) ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showErrorDialog(
          context, 'Login Failed', e.message ?? 'An unknown error occurred.');
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(context, 'Error', 'An unexpected error occurred: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.grass, size: 80, color: deepGreen),
              const SizedBox(height: 16),
              Text(
                localizations.appName,
                style: GoogleFonts.poppins(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: deepGreen),
              ),
              Text(
                "AI-Powered Herd Analysis",
                style: GoogleFonts.poppins(
                    fontSize: 18, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),
              _buildInputField(Icons.email_outlined, "Email", _emailController),
              const SizedBox(height: 20),
              _buildInputField(
                  Icons.lock_outline, "Password", _passwordController,
                  isPassword: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => _signIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 5,
                  ),
                  child: Text(localizations.logInButton),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                    "Don't have an account? ${localizations.signUpButton}",
                    style: GoogleFonts.poppins(color: deepGreen)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      IconData icon, String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType:
          isPassword ? TextInputType.text : TextInputType.emailAddress,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFF0F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }
}

// --- 4. Sign Up Page UI (Unchanged) ---
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showErrorDialog(
          context, 'Sign Up Failed', e.message ?? 'An unknown error occurred.');
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(context, 'Error', 'An unexpected error occurred: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(localizations.signUpButton,
            style: GoogleFonts.poppins(color: deepGreen)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: deepGreen),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInputField(
                  Icons.person_outline, "Full Name", _nameController),
              const SizedBox(height: 20),
              _buildInputField(Icons.email_outlined, "Email", _emailController),
              const SizedBox(height: 20),
              _buildInputField(Icons.lock_outline,
                  "Password (min 6 characters)", _passwordController,
                  isPassword: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => _signUp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 5,
                  ),
                  child: Text(localizations.signUpButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      IconData icon, String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType:
          isPassword ? TextInputType.text : TextInputType.emailAddress,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFF0F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }
}

// --- 5. Home Page (UPDATED) ---
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _currentBreedSpotlightIndex = 0;
  final ImagePicker _picker =
      ImagePicker(); // 🟢 ADDED FOR DIRECT IMAGE PICKING

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/classify');
        break;
      case 2:
        Navigator.pushNamed(
            context, '/realtime'); // 🟢 CHANGED TO REALTIME CAMERA
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
      default:
        break;
    }
  }

  void _nextBreed() {
    setState(() {
      _currentBreedSpotlightIndex =
          (_currentBreedSpotlightIndex + 1) % breedSpotlights.length;
    });
  }

  void _previousBreed() {
    setState(() {
      _currentBreedSpotlightIndex =
          (_currentBreedSpotlightIndex - 1 + breedSpotlights.length) %
              breedSpotlights.length;
    });
  }

  // 🟢 ADDED: Direct image picking from home screen
  Future<void> _pickAndAnalyzeImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final imageFile = File(pickedFile.path);

      // Navigate to classification page with the image
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/classify',
          arguments: {'preSelectedImage': imageFile},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final Color primaryGreen = Theme.of(context).primaryColor;
    final Color deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    final currentUser = FirebaseAuth.instance.currentUser;
    final userName = currentUser?.displayName?.split(' ').first ??
        currentUser?.email?.split('@').first ??
        'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          localizations.appName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: deepGreen,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: deepGreen),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryGreen.withOpacity(0.05),
                    Colors.white.withOpacity(0.9)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(localizations.welcomeGreeting(userName),
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600)),
                  Text(localizations.analyzeHerd,
                      style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: deepGreen)),
                  const SizedBox(height: 20),
                  Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    _modernActionButton(
        context,
        Icons.photo_library_outlined,
        localizations.galleryButton,
        () => _pickAndAnalyzeImage(ImageSource.gallery),
        deepGreen),
    _modernActionButton(
        context,
        Icons.camera_alt_outlined,
        localizations.cameraButton,
        () => _pickAndAnalyzeImage(ImageSource.camera),
        deepGreen),
    _modernActionButton(context, Icons.help_outline,
        localizations.howToButton, () {
      Navigator.pushNamed(context, '/howto');
    }, deepGreen),
    // 🟢 ADD THIS MISSING BREEDS BUTTON:
    _modernActionButton(
        context, Icons.pets_outlined, 'Breeds', () {
      Navigator.pushNamed(context, '/breeds');
    }, deepGreen),
  ],
),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                localizations.spotlightHeader,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: deepGreen),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: screenHeight * 0.35,
              child: _buildModernCard(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ModelViewer(
                    src: breedSpotlights[_currentBreedSpotlightIndex]
                        ['model_src']!,
                    autoRotate: true,
                    cameraControls: true,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                localizations.traitsHeader,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: deepGreen),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 250,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: deepGreen, size: 24),
                      onPressed: _previousBreed,
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: _BreedSpotlightCard(
                          key: ValueKey(_currentBreedSpotlightIndex),
                          breed: breedSpotlights[_currentBreedSpotlightIndex],
                          deepGreen: deepGreen,
                          localizations: localizations,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios,
                          color: deepGreen, size: 24),
                      onPressed: _nextBreed,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/chat');
        },
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
        elevation: 6.0,
        icon: const Icon(Icons.chat),
        label: Text(localizations.chatSupport),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildModernBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
        deepGreen: deepGreen,
        localizations: localizations,
      ),
    );
  }

  Widget _buildModernCard({required Widget child, double? height}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(-5, -5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.5),
              offset: const Offset(5, 5),
              blurRadius: 15,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: child,
        ),
      ),
    );
  }

  Widget _modernActionButton(BuildContext context, IconData icon, String label,
      VoidCallback onTap, Color deepGreen) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: deepGreen.withOpacity(0.15),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: const Offset(-2, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(icon, color: deepGreen, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildModernBottomNavBar({
    required int selectedIndex,
    required Function(int) onTap,
    required Color deepGreen,
    required AppLocalizations localizations,
  }) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 10.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
                child: _buildNavItem(Icons.home_outlined, localizations.home, 0,
                    selectedIndex, deepGreen, onTap)),
            Expanded(
                child: _buildNavItem(
                    Icons.qr_code_scanner,
                    localizations.classify,
                    1,
                    selectedIndex,
                    deepGreen,
                    onTap)),
            Expanded(
                child: _buildNavItem(
                    Icons.camera_alt_outlined, // 🟢 CHANGED ICON
                    'Realtime Camera', // 🟢 CHANGED LABEL
                    2,
                    selectedIndex,
                    deepGreen,
                    onTap)),
            Expanded(
                child: _buildNavItem(
                    Icons.settings_outlined,
                    localizations.settingsTitle,
                    3,
                    selectedIndex,
                    deepGreen,
                    onTap)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      int selectedIndex, Color activeColor, Function(int) onTap) {
    final bool isSelected = index == selectedIndex;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? activeColor : Colors.grey.shade400,
                size: isSelected ? 30 : 26),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widget for Swiping Cards (UPDATED) ---
class _BreedSpotlightCard extends StatelessWidget {
  final Map<String, String> breed;
  final Color deepGreen;
  final AppLocalizations localizations;

  const _BreedSpotlightCard(
      {required this.breed,
      required this.deepGreen,
      required this.localizations,
      super.key});

  String _lookup(String key) {
    return lookupLocalization(localizations, key);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: deepGreen.withOpacity(0.1),
            offset: const Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_lookup(breed['nameKey']!),
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: deepGreen)),
            const SizedBox(height: 4),
            Text("${localizations.origin}: ${_lookup(breed['originKey']!)}",
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.grey.shade600)),
            const Spacer(),
            // Using the SHORT trait key to prevent overflow
            _buildTraitRow(
                Icons.grade_outlined,
                "${localizations.keyTrait}: ${_lookup(breed['traitShortKey']!)}",
                deepGreen),
            const SizedBox(height: 8),
            _buildTraitRow(
                Icons.opacity_outlined,
                "${localizations.milkYield}: ${_lookup(breed['yieldKey']!)}",
                deepGreen),
            const SizedBox(height: 8),
            _buildTraitRow(
                Icons.attach_money,
                "${localizations.marketValue}: ${_lookup(breed['valueKey']!)}",
                deepGreen),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  // Navigate to the detail page with the breed data
                  Navigator.pushNamed(context, '/breedDetail',
                      arguments: breed);
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                label: Text(localizations.viewDetails),
                style: TextButton.styleFrom(
                    foregroundColor: deepGreen,
                    textStyle: GoogleFonts.poppins(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTraitRow(IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ADD THIS MISSING WIDGET CLASS

class ClassificationPage extends StatefulWidget {
  const ClassificationPage({super.key});

  @override
  _ClassificationPageState createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  final ClassificationService _classificationService = ClassificationService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  File? _preSelectedImage;
  bool _isInitialized = false; // Add a flag to run the check only once

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if this is the first time didChangeDependencies is called
    if (!_isInitialized) {
      _checkForPreSelectedImage();
      _isInitialized = true; // Set the flag to true after running
    }
  }

  // 🟢 ADDED: Check for pre-selected images from home screen
  void _checkForPreSelectedImage() {
    // This is now safe to call here
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args.containsKey('preSelectedImage')) {
      // Use addPostFrameCallback to ensure the build is complete
      // before starting analysis, which might trigger state changes.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _preSelectedImage = args['preSelectedImage'];
          });
          _analyzeImage(_preSelectedImage!);
        }
      });
    }
  }

  // 🟢 ADDED: Separate analyze method for reusability

  Future<void> _analyzeImage(File imageFile) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // The 'await' will now throw an error if something goes wrong
      final results = await _classificationService.classifyImage(imageFile);

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/result',
          arguments: {'image': imageFile, 'results': results},
        );
      }
    } catch (e) {
      // The 'catch' block now handles any error from the service
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error: ${e.toString().replaceFirst("Exception: ", "")}')),
        );
        // Pop back to the home screen on failure
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _pickAndAnalyzeImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final imageFile = File(pickedFile.path);
      _analyzeImage(imageFile);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(localizations.classify),
        centerTitle: true,
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      'Analyzing Image...',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.useAIModel,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                          height: 1.4),
                    ),
                    const SizedBox(height: 60),
                    _buildModernClassificationButton(
                      context,
                      icon: Icons.photo_library_outlined,
                      label: localizations.selectFromGallery,
                      onPressed: () =>
                          _pickAndAnalyzeImage(ImageSource.gallery),
                    ),
                    const SizedBox(height: 40),
                    _buildModernClassificationButton(
                      context,
                      icon: Icons.camera_alt_outlined,
                      label: localizations.captureLiveImage,
                      onPressed: () => _pickAndAnalyzeImage(ImageSource.camera),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildModernClassificationButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final Color deepGreen = Theme.of(context).colorScheme.secondary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: deepGreen.withOpacity(0.25),
            offset: const Offset(0, 8),
            blurRadius: 15,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 30),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: deepGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 80),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
      ),
    );
  }
}

// --- 7. Settings Page (Unchanged) ---
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;
    final localeManager = ListenableProvider.of<LocaleManager>(context);

    final currentLanguageName =
        localeManager.languageMap[localeManager.locale.languageCode] ??
            'English (US)';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.person_outline, color: deepGreen),
            title: Text(localizations.accountProfile,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text(localizations.manageDetails),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.language, color: deepGreen),
            title: Text(localizations.language,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text(currentLanguageName),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/language');
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics_outlined, color: deepGreen),
            title: Text(localizations.modelInfo,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text(localizations.modelInfoSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Model Info page
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.support_agent_outlined, color: deepGreen),
            title: Text(localizations.helpSupport,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text(localizations.helpSupportSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          ListTile(
            leading: Icon(Icons.policy_outlined, color: deepGreen),
            title: Text(localizations.privacyPolicy,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pushNamed(context, '/privacy');
            },
          ),
        ],
      ),
    );
  }
}

// --- 8. Account & Profile Page (Unchanged) ---
class AccountProfilePage extends StatefulWidget {
  const AccountProfilePage({super.key});

  @override
  _AccountProfilePageState createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  String _userName = 'N/A';
  String _userEmail = 'N/A';
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _userName = currentUser?.displayName ?? "New User";
    _userEmail = currentUser?.email ?? "email@example.com";
    _nameController.text = _userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    if (_nameController.text.trim().isEmpty ||
        _nameController.text == _userName) {
      setState(() => _isEditingName = false);
      return;
    }

    try {
      await currentUser?.updateDisplayName(_nameController.text.trim());
      await currentUser?.reload();
      setState(() {
        _userName = _nameController.text.trim();
        _isEditingName = false;
      });
      if (mounted) _showSnackbar("Name updated successfully!", Colors.green);
    } catch (e) {
      if (mounted) _showSnackbar("Failed to update name.", Colors.red);
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text.length < 6) {
      _showSnackbar(
          "New password must be at least 6 characters.", Colors.orange);
      return;
    }

    try {
      await currentUser?.updatePassword(_newPasswordController.text.trim());
      if (mounted) {
        _showSnackbar("Password changed successfully!", Colors.green);
      }
      _oldPasswordController.clear();
      _newPasswordController.clear();
    } catch (e) {
      if (mounted) {
        _showSnackbar(
            "Failed to change password. Please re-login and try again.",
            Colors.red);
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(localizations.accountProfile),
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: deepGreen.withOpacity(0.1),
                    child: Icon(Icons.person, size: 40, color: deepGreen),
                  ),
                  const SizedBox(height: 16),
                  Text(_userName,
                      style: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.w700)),
                  Text(_userEmail,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey.shade600)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Text(localizations.personalDetails,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: deepGreen)),
            const Divider(color: Colors.grey, height: 20),
            _buildDetailTile(
              context,
              localizations.displayName,
              _isEditingName ? null : _userName,
              Icons.badge_outlined,
              deepGreen,
              onEditTap: () => setState(() => _isEditingName = !_isEditingName),
              isEditable: true,
            ),
            if (_isEditingName) _buildNameEditField(deepGreen, localizations),
            _buildDetailTile(
              context,
              localizations.emailReadOnly,
              _userEmail,
              Icons.email_outlined,
              deepGreen,
              isEditable: false,
            ),
            const SizedBox(height: 40),
            Text(localizations.security,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: deepGreen)),
            const Divider(color: Colors.grey, height: 20),
            _buildPasswordChangeFields(deepGreen, localizations),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(localizations.changePasswordButton,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(BuildContext context, String title, String? value,
      IconData icon, Color color,
      {VoidCallback? onEditTap, bool isEditable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey.shade700)),
                if (value != null)
                  Text(value,
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (isEditable)
            IconButton(
              icon: Icon(_isEditingName ? Icons.check_circle : Icons.edit,
                  color: color),
              onPressed: _isEditingName ? _updateName : onEditTap,
            ),
        ],
      ),
    );
  }

  Widget _buildNameEditField(Color color, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: localizations.newDisplayNameHint,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.close),
        ),
      ),
    );
  }

  Widget _buildPasswordChangeFields(
      Color color, AppLocalizations localizations) {
    return Column(
      children: [
        _buildSecureInputField(Icons.lock_outline,
            localizations.oldPasswordHint, _oldPasswordController),
        const SizedBox(height: 15),
        _buildSecureInputField(Icons.vpn_key_outlined,
            localizations.newPasswordHint, _newPasswordController),
      ],
    );
  }

  Widget _buildSecureInputField(
      IconData icon, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }
}

// --- 9. Language Selection Page ---
class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(localizations.language),
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: ListenableProvider.of<LocaleManager>(context)
            .languageMap
            .entries
            .map((entry) {
          final langCode = entry.key;
          final languageName = entry.value;
          final isSelected =
              langCode == Localizations.localeOf(context).languageCode;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isSelected
                  ? BorderSide(color: deepGreen, width: 2)
                  : BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              title: Text(
                languageName,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? deepGreen : Colors.black,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: deepGreen)
                  : null,
              onTap: () {
                ListenableProvider.of<LocaleManager>(context)
                    .setLocale(langCode);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

// --- 10. Chat Screen (Unchanged) ---
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Hello! I'm your AI Cattle Assistant. Ask me anything about Indian cattle breeds, milk yields, or diseases!",
      sender: MessageSender.ai,
    ),
  ];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMessage =
        ChatMessage(text: text.trim(), sender: MessageSender.user);
    _textController.clear();

    final loadingMessage = ChatMessage(
        text: "Thinking...", sender: MessageSender.ai, isLoading: true);

    setState(() {
      _messages.add(userMessage);
      _messages.add(loadingMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    final aiResponseText = await _chatService.askQuestion(userMessage.text);

    if (mounted) {
      setState(() {
        _messages.removeLast();

        final isError = aiResponseText.toLowerCase().contains('error:');
        final aiMessage = ChatMessage(
          text: aiResponseText,
          sender: MessageSender.ai,
          isError: isError,
        );
        _messages.add(aiMessage);
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deepGreen = Theme.of(context).colorScheme.secondary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(localizations.chatSupport),
        backgroundColor: deepGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index], deepGreen);
              },
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(localizations),
        ],
      ),
    );
  }

  Widget _buildTextComposer(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: 'Ask your cattle question...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
              ),
              textInputAction: TextInputAction.send,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send),
              onPressed: _isLoading
                  ? null
                  : () => _handleSubmitted(_textController.text),
              color: _isLoading
                  ? Colors.grey
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, Color deepGreen) {
    final bool isUser = message.sender == MessageSender.user;
    final Color bubbleColor = message.isError
        ? Colors.red.shade100
        : isUser
            ? deepGreen
            : Colors.white;
    final Color textColor = message.isError
        ? Colors.red.shade900
        : isUser
            ? Colors.white
            : Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: deepGreen.withOpacity(0.1),
              radius: 12,
              child: Icon(Icons.psychology, size: 12, color: deepGreen),
            ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(15.0).copyWith(
                  topLeft: isUser
                      ? const Radius.circular(15.0)
                      : const Radius.circular(0.0),
                  topRight: isUser
                      ? const Radius.circular(0.0)
                      : const Radius.circular(15.0),
                ),
                border: message.isError
                    ? Border.all(color: Colors.red.shade700, width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: message.isLoading
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.grey),
                    )
                  : Text(
                      message.text,
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: message.isError
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
            ),
          ),
          if (isUser) const SizedBox(width: 8.0),
          if (isUser)
            CircleAvatar(
              backgroundColor: deepGreen,
              radius: 12,
              child: const Icon(Icons.person, size: 12, color: Colors.white),
            ),
        ],
      ),
    );
  }
}

// --- 11. Help & Support Page (Localized) ---
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
              localizations.helpFaqTitle,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: deepGreen,
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              context,
              localizations.helpFaq1Question,
              localizations.helpFaq1Answer,
            ),
            _buildFaqItem(
              context,
              localizations.helpFaq2Question,
              localizations.helpFaq2Answer,
            ),
            _buildFaqItem(
              context,
              localizations.helpFaq3Question,
              localizations.helpFaq3Answer,
            ),
            const Divider(height: 40),
            Text(
              localizations.helpContactTitle,
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
              localizations.helpContactEmailTitle,
              localizations.helpContactEmailAddress,
            ),
            _buildContactItem(
              context,
              Icons.phone_outlined,
              localizations.helpContactPhoneTitle,
              localizations.helpContactPhoneNumber,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                localizations.helpAppVersion,
                style: GoogleFonts.poppins(color: Colors.grey.shade500),
              ),
            )
          ],
        ),
      ),
    );
  }

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

// --- 12. Privacy Policy Page (Localized) ---
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
              localizations.privacyTitle,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.privacyLastUpdated,
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 20),
            _buildPolicySection(
              localizations.privacySection1Title,
              localizations.privacySection1Content,
            ),
            _buildPolicySection(
              localizations.privacySection2Title,
              localizations.privacySection2Content,
            ),
            _buildPolicySection(
              localizations.privacySection3Title,
              localizations.privacySection3Content,
            ),
            _buildPolicySection(
              localizations.privacySection4Title,
              localizations.privacySection4Content,
            ),
            _buildPolicySection(
              localizations.privacySection5Title,
              localizations.privacySection5Content,
            ),
            const SizedBox(height: 20),
            Text(
              localizations.privacyDisclaimer,
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

// --- 13. How To Page (Interactive) ---
class HowToPage extends StatelessWidget {
  const HowToPage({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStepTile(
            context: context,
            stepNumber: '1',
            title: localizations.howToStep1Title,
            content: localizations.howToStep1Content,
            deepGreen: deepGreen,
          ),
          _buildStepTile(
            context: context,
            stepNumber: '2',
            title: localizations.howToStep2Title,
            content: localizations.howToStep2Content,
            deepGreen: deepGreen,
          ),
          _buildStepTile(
            context: context,
            stepNumber: '3',
            title: localizations.howToStep3Title,
            content: localizations.howToStep3Content,
            deepGreen: deepGreen,
          ),
          _buildStepTile(
            context: context,
            stepNumber: '4',
            title: localizations.howToStep4Title,
            content: localizations.howToStep4Content,
            deepGreen: deepGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildStepTile({
    required BuildContext context,
    required String stepNumber,
    required String title,
    required String content,
    required Color deepGreen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: deepGreen,
          foregroundColor: Colors.white,
          child: Text(stepNumber,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        ),
        title: Text(title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        iconColor: deepGreen,
        collapsedIconColor: Colors.grey.shade600,
        children: [
          Text(
            content,
            style:
                GoogleFonts.poppins(color: Colors.grey.shade800, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// --- 14. Breed Detail Page (Unchanged) ---
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
