// File: lib/authenticationscreen/relationship_preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'registration_controller.dart';
import '../dashboard/dashboard_screen.dart';

class RelationshipPreferencesScreen extends StatefulWidget {
  const RelationshipPreferencesScreen({Key? key}) : super(key: key);

  @override
  _RelationshipPreferencesScreenState createState() =>
      _RelationshipPreferencesScreenState();
}

class _RelationshipPreferencesScreenState
    extends State<RelationshipPreferencesScreen> with SingleTickerProviderStateMixin{
  final RegistrationController registrationController =
  Get.find<RegistrationController>();

  String? _selectedRelationshipType;
  final TextEditingController _partnerHeightController =
  TextEditingController();
  final List<String> _selectedTraits = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Sample relationship types
  final List<String> _relationshipTypes = [
    'Casual Dating',
    'Long-Term Relationship',
    'Friendship',
    'Not Sure',
  ];

  // Sample personality traits. Expand!
  final List<String> _personalityTraits = [
    'Kind',
    'Adventurous',
    'Humorous',
    'Intelligent',
    'Creative',
    'Outgoing',
    'Calm',
    'Supportive',
  ];


  @override
  void initState() {
    super.initState();

    // Pre-fill if navigating back
    if (registrationController.relationshipType.value.isNotEmpty) {
      _selectedRelationshipType = registrationController.relationshipType.value;
    }
    if (registrationController.partnerHeightPreference.value.isNotEmpty) {
      _partnerHeightController.text =
          registrationController.partnerHeightPreference.value;
    }
    _selectedTraits.addAll(registrationController.partnerPersonalityTraits);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    // Don't start the animation automatically
    // _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _partnerHeightController.dispose();
    super.dispose();
  }

  void _finishRegistration() {
    if (_selectedRelationshipType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a relationship type.')),
      );
      return;
    }

    registrationController.updateRelationshipPreferences(
      _selectedRelationshipType!,
      _partnerHeightController.text.trim(),
      List.from(_selectedTraits),
    );

    Get.offAll(() => const DashboardScreen());
  }

  double _calculateItemAnimationValue(BuildContext context, int index, double scrollPosition) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return 0.0;

    final position = box.localToGlobal(Offset.zero);
    final itemTop = position.dy;
    final screenHeight = MediaQuery.of(context).size.height;
    final visibleHeight = screenHeight - itemTop + scrollPosition;

    // Adjust this factor to control the speed of the fade-in
    double animationValue = (visibleHeight / screenHeight * 2).clamp(0.0, 1.0);
    return animationValue;
  }


  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relationship Preferences"),
        backgroundColor: currentTheme.appBarTheme.backgroundColor,
        iconTheme: currentTheme.appBarTheme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                setState(() {}); // Trigger a rebuild on scroll
              }
              return true;
            },
            child: ListView(
              clipBehavior: Clip.none,
              children: [
                const Text(
                  "What Are You Looking For?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'LoveDays',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Help us match you with people who are looking for the same things.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Relationship Type
                Container(
                  decoration: BoxDecoration(
                    color: currentTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRelationshipType,
                    decoration: const InputDecoration(
                      labelText: 'Relationship Type',
                      prefixIcon: Icon(Icons.favorite_outline),
                      border: InputBorder.none,
                    ),
                    items: _relationshipTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRelationshipType = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Partner Height Preference
                Container(
                  decoration: BoxDecoration(
                    color: currentTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _partnerHeightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Preferred Partner Height (cm) - Optional',
                      prefixIcon: Icon(Icons.height),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Partner Personality Traits
                const Text(
                  "Preferred Partner Personality Traits",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _personalityTraits.asMap().entries.map((entry) {
                    final index = entry.key;
                    final trait = entry.value;
                    return LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final itemAnimationValue = _calculateItemAnimationValue(context, index, 0);
                              return Transform.scale(
                                scale: 0.9 + (0.1 * itemAnimationValue),
                                child: Opacity(
                                  opacity: itemAnimationValue,
                                  child: child,
                                ),
                              );
                            },
                            child: FilterChip(
                              label: Text(trait),
                              selected: _selectedTraits.contains(trait),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedTraits.add(trait);
                                  } else {
                                    _selectedTraits.remove(trait);
                                  }
                                });
                              },
                              backgroundColor: currentTheme.colorScheme.surface,
                              selectedColor: currentTheme.colorScheme.primary.withOpacity(0.2),
                              checkmarkColor: currentTheme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: _selectedTraits.contains(trait)
                                      ? currentTheme.colorScheme.primary
                                      : Colors.grey.withOpacity(0.3),
                                  width: _selectedTraits.contains(trait) ? 2 : 1,
                                ),
                              ),
                            ),
                          );
                        }
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _finishRegistration,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: currentTheme.colorScheme.primary,
                      foregroundColor: currentTheme.colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5),
                  child: const Text("Finish Registration",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}