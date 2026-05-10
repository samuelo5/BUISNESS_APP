import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/auth/screens/setup_screen.dart';
import 'features/dashboard/screens/main_shell.dart';
import 'features/subscription/screens/subscription_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");
  
  // NOTE: This will fail until the user adds their own google-services.json
  // or runs `flutterfire configure`. On Web, explicit options are required.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('---------------------------------------------------------');
    debugPrint('Firebase Initialization Note:');
    debugPrint('The app is running in DEMO MODE because Firebase keys');
    debugPrint('are not yet configured for this platform.');
    debugPrint('Error: $e');
    debugPrint('---------------------------------------------------------');
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const BizAIApp());
}

class BizAIApp extends StatelessWidget {
  const BizAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..loadPreferences()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer2<AppProvider, AuthProvider>(
        builder: (context, appProvider, authProvider, _) {
          return MaterialApp(
            title: 'BizAI Assistant',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AuthRoot(),
            routes: {
              '/onboarding': (_) => const OnboardingScreen(),
              '/login': (_) => const LoginScreen(),
              '/signup': (_) => const SignupScreen(),
              '/setup': (_) => const SetupScreen(),
              '/home': (_) => const MainShell(),
              '/subscription': (_) => const SubscriptionScreen(),
              '/settings': (_) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}

class AuthRoot extends StatelessWidget {
  const AuthRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final app = context.watch<AppProvider>();

    // 1. Splash / Loading
    if (auth.status == AuthStatus.uninitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Not Logged In -> Show Onboarding or Login
    if (auth.status == AuthStatus.unauthenticated) {
      return const OnboardingScreen();
    }

    // 3. Logged In -> Home (with dynamic check for profile setup)
    if (app.userName.isEmpty) {
      return const SetupScreen();
    }
    
    return const MainShell();
  }
}
