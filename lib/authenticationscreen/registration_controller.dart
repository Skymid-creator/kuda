// File: lib/authenticationscreen/registration_controller.dart
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  // Existing Observables (name, email, password, city, gender, preferences, etc.)
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var city = ''.obs;
  var gender = ''.obs;
  var preferences = {}.obs; // Preferences stored as a Map
  var bookGenres = ''.obs;
  var favoriteMusic = ''.obs;
  var artPreferences = ''.obs;
  var moviePreferences = ''.obs;
  var sportPreferences = ''.obs;
  var travelPreferences = ''.obs;
  var foodPreferences = ''.obs;

  // NEW: Personal Details
  var height = ''.obs;
  var personalityAnswers = <String, String>{}.obs; // Question ID -> Answer

  // NEW: Relationship Preferences
  var relationshipType = ''.obs;
  var partnerHeightPreference = ''.obs;
  var partnerPersonalityTraits = <String>[].obs; // List of desired traits

  // Existing update methods
  void updateBasicInfo({
    required String name,
    required String email,
    required String password,
    required String city,
  }) {
    this.name.value = name;
    this.email.value = email;
    this.password.value = password;
    this.city.value = city;
  }

  void updateGender(String gender) {
    this.gender.value = gender;
  }

  void updatePreferences(
      Map<String, bool> preferences,
      String bookGenres,
      String favoriteMusic,
      [String artPrefs = '',
        String moviePrefs = '',
        String sportPrefs = '',
        String travelPrefs = '',
        String foodPrefs = '']
      ) {
    this.preferences.value = preferences;
    this.bookGenres.value = bookGenres;
    this.favoriteMusic.value = favoriteMusic;
    this.artPreferences.value = artPrefs;
    this.moviePreferences.value = moviePrefs;
    this.sportPreferences.value = sportPrefs;
    this.travelPreferences.value = travelPrefs;
    this.foodPreferences.value = foodPrefs;
  }

  // NEW: Update Personal Details
  void updatePersonalDetails(String height, Map<String, String> answers) {
    this.height.value = height;
    this.personalityAnswers.value = answers;
  }

  // NEW: Update Relationship Preferences
  void updateRelationshipPreferences(
      String type, String heightPref, List<String> traits) {
    this.relationshipType.value = type;
    this.partnerHeightPreference.value = heightPref;
    this.partnerPersonalityTraits.value = traits;
  }

  // Clear all data (optional, for logout or clearing registration)
  void clearAllData() {
    name.value = '';
    email.value = '';
    password.value = '';
    city.value = '';
    gender.value = '';
    preferences.clear();
    bookGenres.value = '';
    favoriteMusic.value = '';
    artPreferences.value = '';
    moviePreferences.value = '';
    sportPreferences.value = '';
    travelPreferences.value = '';
    foodPreferences.value = '';
    height.value = '';
    personalityAnswers.clear();
    relationshipType.value = '';
    partnerHeightPreference.value = '';
    partnerPersonalityTraits.clear();
  }
}