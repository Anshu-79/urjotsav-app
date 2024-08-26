import 'dart:ui';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextStyle loginPageHeader = const TextStyle(
    fontFamily: 'Megrim',
    fontSize: 100,
    color: Colors.white,
    fontWeight: FontWeight.bold);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAdmin = false;

  Widget loginToggle() {
    return AnimatedToggleSwitch<bool>.size(
      textDirection: TextDirection.rtl,
      current: isAdmin,
      values: const [false, true],
      iconBuilder: (value) =>
          value ? const Text("Sign Up") : const Text("Login"),
      indicatorSize: const Size.fromWidth(100),
      borderWidth: 4.0,
      iconAnimationType: AnimationType.onHover,
      style: ToggleStyle(
        borderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      styleBuilder: (i) =>
          ToggleStyle(indicatorColor: Theme.of(context).primaryColor),
      onChanged: (i) => setState(() => isAdmin = i),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const LoginBackground(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutoSizeText("URJOTSAV", style: loginPageHeader, maxLines: 1),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      loginToggle(),
                    ],
                  ),
                ).frosted(borderRadius: BorderRadius.circular(30))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/login_bg.jpg'),
          fit: BoxFit.fitHeight),
    )).blurred(colorOpacity: 0.1);
  }
}
