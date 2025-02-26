// File: lib/authenticationscreen/gender_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'registration_controller.dart';
import 'preference_screen.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> with SingleTickerProviderStateMixin {
  final RegistrationController registrationController = Get.find<RegistrationController>();
  String? selectedGender;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> genderOptions = [
    {'title': 'Male', 'icon': Icons.male, 'color': Colors.blue},
    {'title': 'Female', 'icon': Icons.female, 'color': Colors.pink},
    {'title': 'Non-binary', 'icon': Icons.people, 'color': Colors.purple},
    {'title': 'Prefer not to say', 'icon': Icons.person, 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void _continueToPreferences() {
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select your gender"))
      );
      return;
    }

    // Save selected gender to the controller
    registrationController.updateGender(selectedGender!);

    // Navigate to preferences screen
    Get.to(() => const PreferencesScreen(), transition: Transition.rightToLeft);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("About You"),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Column(
                  children: [
                    Text(
                      "How do you identify?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'LoveDays',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Select your gender to help us personalize your experience",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: genderOptions.length,
                  itemBuilder: (context, index) {
                    final option = genderOptions[index];
                    final isSelected = selectedGender == option['title'];

                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final delay = index * 0.2;
                        final startValue = _animationController.value > delay ? _animationController.value - delay : 0.0;
                        final itemAnimationValue = startValue < 0.0 ? 0.0 : (startValue > 1.0 ? 1.0 : startValue);

                        return Transform.scale(
                          scale: 0.6 + (0.4 * itemAnimationValue),
                          child: Opacity(
                            opacity: itemAnimationValue,
                            child: child,
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () => _selectGender(option['title']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? option['color'].withOpacity(0.2)
                                : currentTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? option['color'] : Colors.grey.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? option['color'].withOpacity(0.2)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                option['icon'],
                                size: 48,
                                color: isSelected ? option['color'] : Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                option['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? option['color'] : currentTheme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Adding the Continue Button that was missing
              ElevatedButton(
                onPressed: _continueToPreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentTheme.colorScheme.primary,
                  foregroundColor: currentTheme.colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}