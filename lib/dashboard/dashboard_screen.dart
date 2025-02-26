// File: lib/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../authenticationscreen/registration_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final RegistrationController registrationController = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Interest Connect"),
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Registration Complete!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your profile has been created successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                Obx(() {
                  // Display user information
                  final selectedInterests = registrationController.preferences.entries
                      .where((entry) => entry.value == true)
                      .map((entry) => entry.key)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoTile("Name", registrationController.name.value),
                      _buildInfoTile("Gender", registrationController.gender.value),
                      _buildInfoTile("Interests", selectedInterests.join(", ")),
                      if (registrationController.preferences['Books'] == true)
                        _buildInfoTile("Book Genres", registrationController.bookGenres.value),
                      if (registrationController.preferences['Music'] == true)
                        _buildInfoTile("Music", registrationController.favoriteMusic.value),
                      // Add other details
                      if (registrationController.preferences['Art'] == true)
                        _buildInfoTile("Art", registrationController.artPreferences.value),
                      if (registrationController.preferences['Movies & TV'] == true)
                        _buildInfoTile("Movies & TV", registrationController.moviePreferences.value),
                      if (registrationController.preferences['Sports'] == true)
                        _buildInfoTile("Sports", registrationController.sportPreferences.value),
                      if (registrationController.preferences['Travel'] == true)
                        _buildInfoTile("Travel", registrationController.travelPreferences.value),
                      if (registrationController.preferences['Food'] == true)
                        _buildInfoTile("Food", registrationController.foodPreferences.value),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "Not specified" : value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}