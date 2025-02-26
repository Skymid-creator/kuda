// File: lib/authenticationscreen/preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'registration_controller.dart';
import '../widgets/custom_text_field_widget.dart';
import '../dashboard/dashboard_screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final RegistrationController registrationController = Get.find<RegistrationController>();
  final ScrollController _scrollController = ScrollController();

  // Text controllers for specific preferences
  final TextEditingController bookGenresController = TextEditingController();
  final TextEditingController musicController = TextEditingController();
  final TextEditingController artController = TextEditingController();
  final TextEditingController moviesController = TextEditingController();
  final TextEditingController sportsController = TextEditingController();
  final TextEditingController travelController = TextEditingController();
  final TextEditingController foodController = TextEditingController();

  // Map to store user preferences
  final Map<String, bool> preferences = {
    'Books': false,
    'Music': false,
    'Art': false,
    'Movies & TV': false,
    'Sports': false,
    'Travel': false,
    'Food': false,
    'Religion': false,
    'Spirituality': false,
    'Photography': false,
    'Technology': false,
    'Science': false,
    'Politics': false,
    'Fitness': false,
    'Nature': false,
    'Animals': false,
  };

  // Map to track if the specific preference fields are expanded
  final Map<String, bool> expandedPreferences = {};

  @override
  void initState() {
    super.initState();
    // Initialize all preferences as not expanded
    for (String key in preferences.keys) {
      expandedPreferences[key] = false;
    }
  }

  void _togglePreference(String preference) {
    setState(() {
      preferences[preference] = !preferences[preference]!;

      // If preference is deselected, also collapse its details
      if (!preferences[preference]!) {
        expandedPreferences[preference] = false;
      }
    });
  }

  void _toggleExpand(String preference) {
    // Only toggle if the preference is selected
    if (preferences[preference]!) {
      setState(() {
        expandedPreferences[preference] = !expandedPreferences[preference]!;
      });

      // Scroll to the expanded item after a short delay to allow animation
      if (expandedPreferences[preference]!) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _scrollToCurrentItem(preference);
        });
      }
    }
  }

  void _scrollToCurrentItem(String preference) {
    // Calculate approximate position of the item
    final index = preferences.keys.toList().indexOf(preference);
    if (index != -1) {
      final estimatedPosition = index * 60.0; // Approximate height per item
      _scrollController.animateTo(
        estimatedPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeRegistration() {
    // Ensure at least one preference is selected
    if (!preferences.values.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least one interest"))
      );
      return;
    }

    // Gather specific preferences
    String bookGenres = preferences['Books']! ? bookGenresController.text : '';
    String favoriteMusic = preferences['Music']! ? musicController.text : '';
    String artPrefs = preferences['Art']! ? artController.text : '';
    String moviePrefs = preferences['Movies & TV']! ? moviesController.text : '';
    String sportPrefs = preferences['Sports']! ? sportsController.text : '';
    String travelPrefs = preferences['Travel']! ? travelController.text : '';
    String foodPrefs = preferences['Food']! ? foodController.text : '';

    // Save preferences to controller
    registrationController.updatePreferences(
        preferences,
        bookGenres,
        favoriteMusic,
        artPrefs,
        moviePrefs,
        sportPrefs,
        travelPrefs,
        foodPrefs
    );

    // Navigate to dashboard screen
    Get.offAll(() => const DashboardScreen());
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Interests"),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "What do you like?",
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
                  "Select your interests to find people who share your passions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable list of preferences
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: preferences.length,
              itemBuilder: (context, index) {
                final preference = preferences.keys.elementAt(index);
                final isSelected = preferences[preference]!;
                final isExpanded = expandedPreferences[preference]!;

                return Column(
                  children: [
                    // Preference item
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? currentTheme.colorScheme.primary.withOpacity(0.1)
                            : currentTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8
                        ),
                        title: Text(
                          preference,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? currentTheme.colorScheme.primary
                                : currentTheme.colorScheme.onSurface,
                          ),
                        ),
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (_) => _togglePreference(preference),
                          activeColor: currentTheme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        trailing: isSelected
                            ? IconButton(
                          icon: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: currentTheme.colorScheme.primary,
                          ),
                          onPressed: () => _toggleExpand(preference),
                        )
                            : null,
                      ),
                    ),

                    // Expandable detail section for specific preferences
                    if (isSelected && isExpanded)
                      _buildExpandableContent(preference, currentTheme),
                  ],
                );
              },
            ),
          ),

          // Finish button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: currentTheme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _completeRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: currentTheme.colorScheme.primary,
                foregroundColor: currentTheme.colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
              child: const Text(
                "Finish Registration",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom method to build the expandable content for each preference
  Widget _buildExpandableContent(String preference, ThemeData theme) {
    TextEditingController? controller;
    String hintText = '';
    String labelText = '';
    IconData iconData = Icons.favorite;

    // Assign the appropriate controller and text based on the preference
    switch (preference) {
      case 'Books':
        controller = bookGenresController;
        hintText = 'Fiction, Fantasy, Biography...';
        labelText = 'Favorite book genres';
        iconData = Icons.book;
        break;
      case 'Music':
        controller = musicController;
        hintText = 'Rock, Jazz, Classical...';
        labelText = 'Music genres you enjoy';
        iconData = Icons.music_note;
        break;
      case 'Art':
        controller = artController;
        hintText = 'Modern art, Renaissance...';
        labelText = 'Art styles you appreciate';
        iconData = Icons.palette;
        break;
      case 'Movies & TV':
        controller = moviesController;
        hintText = 'Sci-fi, Drama, Comedy...';
        labelText = 'Favorite movie/TV genres';
        iconData = Icons.movie;
        break;
      case 'Sports':
        controller = sportsController;
        hintText = 'Basketball, Soccer, Yoga...';
        labelText = 'Sports or activities you enjoy';
        iconData = Icons.sports_basketball;
        break;
      case 'Travel':
        controller = travelController;
        hintText = 'Beach, Mountains, Cultural...';
        labelText = 'Travel preferences';
        iconData = Icons.flight;
        break;
      case 'Food':
        controller = foodController;
        hintText = 'Italian, Vegan, Street food...';
        labelText = 'Cuisine preferences';
        iconData = Icons.restaurant;
        break;
      default:
        return Container(); // Empty container for preferences without specific details
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Use a standard TextField instead of CustomTextFieldWidget
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(iconData),
          labelStyle: const TextStyle(
            fontSize: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bookGenresController.dispose();
    musicController.dispose();
    artController.dispose();
    moviesController.dispose();
    sportsController.dispose();
    travelController.dispose();
    foodController.dispose();
    super.dispose();
  }
}