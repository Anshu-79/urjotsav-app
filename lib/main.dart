import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'package:urjotsav/screens/home.dart';
import 'package:urjotsav/screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  static ColorScheme colorScheme = ColorScheme(
      primary: const Color(0xFFEFF3F3),
      onPrimary: Colors.black87,
      secondary: Colors.black87,
      onSecondary: const Color(0xFFEFF3F3),
      error: Colors.redAccent,
      onError: Colors.white,
      surface: const Color(0xFFFAFBFB),
      onSurface: Colors.black87,
      brightness: Brightness.light,
      outline: Colors.blue,
      tertiary: Colors.blueAccent.shade200);

  @override
  Widget build(BuildContext context) {
    bool onboard = prefs.getBool('onboard') ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Jost',
        textTheme: const TextTheme(),
        colorScheme: colorScheme,
        canvasColor: colorScheme.surface,
        scaffoldBackgroundColor: colorScheme.surface,
        highlightColor: Colors.transparent,
        focusColor: colorScheme.primary,
        useMaterial3: true,
      ),
      home: onboard ? const HomeScreen() : LoginScreen(prefs: prefs),
    );
  }
}
