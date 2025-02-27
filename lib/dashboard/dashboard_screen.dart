// File: lib/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../authenticationscreen/registration_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin{
  final RegistrationController registrationController = Get.find<RegistrationController>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Interest Connect"),
        backgroundColor: currentTheme.appBarTheme.backgroundColor,
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
          child: FadeTransition( // Apply FadeTransition
            opacity: _fadeAnimation,
            child: ListView(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Registration Complete!",
                  textAlign: TextAlign.center,
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
                      _buildInfoCard("Name", registrationController.name.value, currentTheme),  // Use _buildInfoCard
                      _buildInfoCard("Gender", registrationController.gender.value, currentTheme),
                      _buildInfoCard("Interests", selectedInterests.join(", "), currentTheme),
                      if (registrationController.preferences['Books'] == true)
                        _buildInfoCard("Book Genres", registrationController.bookGenres.value, currentTheme),
                      if (registrationController.preferences['Music'] == true)
                        _buildInfoCard("Music", registrationController.favoriteMusic.value, currentTheme),
                      if (registrationController.preferences['Art'] == true)
                        _buildInfoCard("Art", registrationController.artPreferences.value, currentTheme),
                      if (registrationController.preferences['Movies & TV'] == true)
                        _buildInfoCard("Movies & TV", registrationController.moviePreferences.value, currentTheme),
                      if (registrationController.preferences['Sports'] == true)
                        _buildInfoCard("Sports", registrationController.sportPreferences.value, currentTheme),
                      if (registrationController.preferences['Travel'] == true)
                        _buildInfoCard("Travel", registrationController.travelPreferences.value, currentTheme),
                      if (registrationController.preferences['Food'] == true)
                        _buildInfoCard("Food", registrationController.foodPreferences.value, currentTheme),
                      _buildInfoCard("Height", registrationController.height.value, currentTheme),
                      if (registrationController.personalityAnswers.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          "Personality Answers:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...registrationController.personalityAnswers.entries.map((entry) {
                          return _buildInfoCard(entry.key, entry.value, currentTheme); // Display question and answer
                        }).toList(),
                      ],
                      _buildInfoCard("Looking For", registrationController.relationshipType.value, currentTheme),
                      _buildInfoCard("Preferred Partner Height", registrationController.partnerHeightPreference.value, currentTheme),
                      if (registrationController.partnerPersonalityTraits.isNotEmpty)
                        _buildInfoCard("Preferred Traits", registrationController.partnerPersonalityTraits.join(", "), currentTheme),
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

  // Helper function to create info cards
  Widget _buildInfoCard(String label, String value, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
        ],
      ),
    );
  }
}