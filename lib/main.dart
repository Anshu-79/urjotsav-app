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

  @override
  Widget build(BuildContext context) {
    bool onboard = prefs.getBool('onboard') ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Jost',
        textTheme: TextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade600),
        useMaterial3: true,
      ),
      home: onboard ? HomeScreen() : LoginScreen(prefs: prefs),
    );
  }
}
