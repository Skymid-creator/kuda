import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Import for RenderObject
import 'package:get/get.dart';
import 'registration_controller.dart';
import 'personal_details_screen.dart';
import 'package:flutter/scheduler.dart'; // Import SchedulerBinding

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final RegistrationController registrationController =
  Get.find<RegistrationController>();
  final ScrollController _scrollController = ScrollController();

  // Use a single controller and dynamically assign it.
  final TextEditingController detailsController = TextEditingController();

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


  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_scrollListener); // REMOVED
  }


  @override
  void dispose() {
    // _scrollController.removeListener(_scrollListener); // REMOVED
    _scrollController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  void _togglePreference(String preference) {
    setState(() {
      preferences[preference] = !preferences[preference]!;
    });
  }

  void _toggleExpand(String preference) {
    if (preferences[preference]!) {
      setState(() {
        final isCurrentlyExpanded = preferences[preference] ?? false;
        preferences[preference] = !isCurrentlyExpanded;

        if (!isCurrentlyExpanded) {
          // Use addPostFrameCallback to ensure layout is complete.
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return; // Check if still mounted

            final index = preferences.keys.toList().indexOf(preference);
            if (index != -1) {
              //Calculate the height of the header widgets
              double headerHeight = 64.0;
              final estimatedPosition = (index * 60.0) + headerHeight;

              // Ensure the scroll position is within bounds before animating
              double maxScrollExtent = _scrollController.position.maxScrollExtent;
              double targetPosition = estimatedPosition.clamp(0.0, maxScrollExtent);

              _scrollController.animateTo(
                targetPosition,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        }
      });
    }
  }

  void _completeRegistration() {
    if (!preferences.values.contains(true)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please select at least one interest")));
      return;
    }

    // Pass the single controller's text to a helper function.
    _updateRegistrationController();
    Get.to(() => const PersonalDetailsScreen());
  }

  void _updateRegistrationController() {
    // Use a Map to match preferences keys to field keys
    Map<String, String> preferenceFields = {
      'Books': 'bookGenres',
      'Music': 'favoriteMusic',
      'Art': 'artPrefs',
      'Movies & TV': 'moviePrefs',
      'Sports': 'sportPrefs',
      'Travel': 'travelPrefs',
      'Food': 'foodPrefs',
    };

    // Create a map to store updated values for each selected preference
    Map<String, String> updatedValues = {};

    // Populate the updatedValues map based on selected preferences
    preferences.forEach((pref, isSelected) {
      if (isSelected && preferenceFields.containsKey(pref)) {
        updatedValues[preferenceFields[pref]!] = detailsController.text;
      }
    });

    // Update all at once in the registration controller
    registrationController.updatePreferences(
        preferences,
        updatedValues['bookGenres'] ?? '',        // Provide default empty strings
        updatedValues['favoriteMusic'] ?? '',
        updatedValues['artPrefs'] ?? '',
        updatedValues['moviePrefs'] ?? '',
        updatedValues['sportPrefs'] ?? '',
        updatedValues['travelPrefs'] ?? '',
        updatedValues['foodPrefs'] ?? ''
    );
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
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: preferences.length + 2, // +2 for header widgets
              itemBuilder: (context, index) {
                // Header Text 1
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "What do you like?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'LoveDays',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  );
                }

                // Header Text 2
                if (index == 1) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Select your interests to find people who share your passions",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                final preferenceIndex = index - 2;
                final preference = preferences.keys.elementAt(preferenceIndex);
                final isSelected = preferences[preference]!;
                final itemKey = ValueKey(preference);

                return
                  Column( // Removed LayoutBuilder
                    key: itemKey,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? currentTheme.colorScheme.primary
                              .withOpacity(0.1)
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
                              horizontal: 16, vertical: 8),
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
                              preferences[preference]!
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: currentTheme.colorScheme.primary,
                            ),
                            onPressed: () => _toggleExpand(preference),
                          )
                              : null,
                        ),
                      ),
                      if (isSelected && preferences[preference]!)
                        _buildExpandableContent(preference, currentTheme),
                    ],
                  );

              },
            ),
          ),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableContent(String preference, ThemeData theme) {
    String hintText = '';
    String labelText = '';
    IconData iconData = Icons.favorite;

    switch (preference) {
      case 'Books':
        hintText = 'Fiction, Fantasy, Biography...';
        labelText = 'Favorite book genres';
        iconData = Icons.book;
        break;
      case 'Music':
        hintText = 'Rock, Jazz, Classical...';
        labelText = 'Music genres you enjoy';
        iconData = Icons.music_note;
        break;
      case 'Art':
        hintText = 'Modern art, Renaissance...';
        labelText = 'Art styles you appreciate';
        iconData = Icons.palette;
        break;
      case 'Movies & TV':
        hintText = 'Sci-fi, Drama, Comedy...';
        labelText = 'Favorite movie/TV genres';
        iconData = Icons.movie;
        break;
      case 'Sports':
        hintText = 'Basketball, Soccer, Yoga...';
        labelText = 'Sports or activities you enjoy';
        iconData = Icons.sports_basketball;
        break;
      case 'Travel':
        hintText = 'Beach, Mountains, Cultural...';
        labelText = 'Travel preferences';
        iconData = Icons.flight;
        break;
      case 'Food':
        hintText = 'Italian, Vegan, Street food...';
        labelText = 'Cuisine preferences';
        iconData = Icons.restaurant;
        break;
      default:
        return Container(); // No additional content
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
      child: TextField(
        controller: detailsController, // Single controller
        maxLines: 3,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(iconData),
          labelStyle: const TextStyle(
            fontSize: 18,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}