import 'package:flutter/material.dart';
import 'package:kuda/authenticationscreen/registration_screen.dart';
import 'package:get/get.dart';
import '../widgets/custom_text_field_widget.dart'; // Import CustomTextFieldWidget
import 'gender_selection_screen.dart';
class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool showProgressBar = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: currentTheme.appBarTheme.backgroundColor,
        iconTheme: currentTheme.appBarTheme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'LoveDays',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                "images/logo.png",
                height: 175,
              ),
              const SizedBox(height: 5),
              const Text(
                "Connecting souls",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'LoveDays',
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 30),

              //email
              CustomTextFieldWidget( // Email field using CustomTextFieldWidget
                editingController: emailTextEditingController,
                labelText: "Email",
                iconData: Icons.email_outlined,
                isObscure: false,
              ),

              const SizedBox(height: 16),

              //password
              CustomTextFieldWidget( // Password field using CustomTextFieldWidget
                editingController: passwordTextEditingController,
                labelText: "Password",
                iconData: Icons.lock_outlined,
                isObscure: true,
              ),

              const SizedBox(height: 30),

              //login button
              ElevatedButton(
                onPressed: () {
                  // Perform login action here
                  if (_formKey.currentState?.validate() ?? false) {
                    // Your login logic here
                    print("Login button pressed");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentTheme.colorScheme.primary,
                  foregroundColor: currentTheme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 16),

              // create new account button
              ElevatedButton(
                onPressed: () {
                  Get.to(() => RegistrationScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Create new account",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  Get.to(() => GenderSelectionScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Im the Developer",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 16),

              showProgressBar == true
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}