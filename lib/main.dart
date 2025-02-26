import 'package:flutter/material.dart';
import 'package:kuda/authenticationscreen/login_screen.dart';
import 'package:get/get.dart';
import 'authenticationscreen/registration_controller.dart';

void main() {
  Get.put(RegistrationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dating App',

      theme: ThemeData(
        colorSchemeSeed: Colors.blue, // Seed color for light theme (e.g., blue)
        useMaterial3: true,
        brightness: Brightness.light, // Explicitly set brightness to light
      ),

      // Dark Theme with ColorScheme and Material 3
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo, // Seed color for dark theme (e.g., indigo)
        useMaterial3: true,
        brightness: Brightness.dark, // Explicitly set brightness to dark
      ),

      themeMode: ThemeMode.system,




      debugShowCheckedModeBanner: false,
      home: loginScreen(),
    );
  }
}

