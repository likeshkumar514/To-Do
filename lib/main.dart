import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_bangl/Screens/Auth/Signup_page.dart';
import 'package:to_do_bangl/Screens/Pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check login state
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(ToDoApp(initialPage: isLoggedIn ? HomePage() : SignupPage()));
}

class ToDoApp extends StatelessWidget {
  final Widget initialPage;

  const ToDoApp({Key? key, required this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialPage,
    );
  }
}
