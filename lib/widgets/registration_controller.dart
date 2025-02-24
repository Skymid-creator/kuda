import 'package:get/get.dart';

class RegistrationController extends GetxController {
  // Observable variables for registration data
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var city = ''.obs;
  var gender = ''.obs;
  var preferences = {}.obs; // Preferences stored as a Map
  var bookGenres = ''.obs;
  var favoriteMusic = ''.obs;

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

  void updatePreferences(Map<String, bool> preferences, String bookGenres, String favoriteMusic) {
    this.preferences.value = preferences;
    this.bookGenres.value = bookGenres;
    this.favoriteMusic.value = favoriteMusic;
  }
}
