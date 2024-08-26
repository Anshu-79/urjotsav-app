import 'dart:ui';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blur/blur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextStyle loginPageHeader = const TextStyle(
    fontFamily: 'Megrim',
    fontSize: 100,
    color: Colors.white,
    fontWeight: FontWeight.bold);

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    debugPrint('exception->$e');
  }
}

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
      iconBuilder: (value) => value
          ? const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.w500))
          : const Text("Admin Login",
              style: TextStyle(fontWeight: FontWeight.w500)),
      indicatorSize: const Size.fromWidth(150),
      borderWidth: 4.0,
      iconAnimationType: AnimationType.onHover,
      style: ToggleStyle(
          indicatorColor: Theme.of(context).colorScheme.tertiary,
          borderColor: Colors.white),
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
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
            child: Column(
              children: [
                AutoSizeText("URJOTSAV", style: loginPageHeader, maxLines: 1),
                const SizedBox(height: 80),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 5),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        loginToggle(),
                        isAdmin ? const GoogleSignUp() : const AdminLogin(),
                        const SizedBox()
                      ],
                    ),
                  ),
                ).frosted(
                    borderRadius: BorderRadius.circular(40),
                    frostColor: Colors.black12),
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

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: emailController,
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2)),
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(30)),
                  labelText: "Email"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2)),
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(30)),
                  labelText: "Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Navigate the user to the Home page
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill input')),
                    );
                  }
                },
                child: const Text('Submit', style: TextStyle(color: Colors.black87, fontSize: 20),)),
          ],
        ),
      ),
    );
  }
}

class GoogleSignUp extends StatefulWidget {
  const GoogleSignUp({super.key});

  @override
  State<GoogleSignUp> createState() => _GoogleSignUpState();
}

class _GoogleSignUpState extends State<GoogleSignUp> {
  ValueNotifier userCredential = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: userCredential,
        builder: (context, value, child) {
          return (userCredential.value == '' || userCredential.value == null)
              ? Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        userCredential.value = await signInWithGoogle();
                        if (userCredential.value != null) {
                          debugPrint(userCredential.value.user!.email);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(children: [
                          Image.asset('assets/images/google_icon.png',
                              width: 40),
                          const SizedBox(width: 10),
                          const AutoSizeText("Sign Up with Google",
                              style: TextStyle(fontSize: 15, color: Colors.black87), maxLines: 1)
                        ]),
                      )),
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 1.5, color: Colors.black54)),
                        child: Image.network(
                            userCredential.value.user!.photoURL.toString()),
                      ),
                      const SizedBox(height: 20),
                      Text(userCredential.value.user!.displayName.toString()),
                      const SizedBox(height: 20),
                      Text(userCredential.value.user!.email.toString()),
                      const SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () async {}, child: const Text('Logout'))
                    ],
                  ),
                );
        });
  }
}
