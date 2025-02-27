// File: lib/authenticationscreen/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'registration_controller.dart';
import '../widgets/custom_text_field_widget.dart';
import './gender_selection_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();

  bool isFetchingLocation = false;
  String? currentLocationError;
  bool locationFetched = false;

  final RegistrationController registrationController = Get.find<RegistrationController>();

  @override
  void initState() {
    super.initState();
    // Make sure the controller is initialized
    if (!Get.isRegistered<RegistrationController>()) {
      Get.put(RegistrationController());
    }
  }

  Future<void> _getLocation() async {
    setState(() {
      isFetchingLocation = true;
      currentLocationError = null;
      locationFetched = false;
      cityController.text = '';
      districtController.text = '';
      stateController.text = '';
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          isFetchingLocation = false;
          currentLocationError = 'Location services are disabled.';
        });
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            isFetchingLocation = false;
            currentLocationError = 'Location permissions are denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          isFetchingLocation = false;
          currentLocationError = 'Location permissions are permanently denied.';
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      // Use more detailed geocoding to improve district detection
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
      );

      if (placemarks.isEmpty) {
        setState(() {
          isFetchingLocation = false;
          currentLocationError = 'Could not determine your location.';
        });
        return;
      }

      Placemark place = placemarks.first;

      // Try multiple placemark properties to find district info
      String district = place.subAdministrativeArea ??
          place.administrativeArea ??
          place.locality ??
          '';

      // Check if in Kerala (for your app's specific requirement)
      bool isInKerala = (place.administrativeArea?.toLowerCase() == 'kerala') ||
          (place.subAdministrativeArea?.toLowerCase()?.contains('kerala') ?? false);

      if (!isInKerala) {
        setState(() {
          isFetchingLocation = false;
          currentLocationError = 'This app is only for people in Kerala.';
        });
        return;
      }

      setState(() {
        cityController.text = place.locality ?? '';
        districtController.text = district;
        stateController.text = place.administrativeArea ?? '';
        isFetchingLocation = false;
        locationFetched = true;
      });
    } catch (e) {
      setState(() {
        isFetchingLocation = false;
        currentLocationError = 'Error fetching location: ${e.toString()}';
      });
    }
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      // Ensure all location fields are filled
      if (cityController.text.isEmpty || districtController.text.isEmpty || stateController.text.isEmpty) {
        setState(() {
          currentLocationError = "Please ensure City, District, and State are filled.";
        });
        return;
      }

      // Ensure passwords match
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords don't match"))
        );
        return;
      }

      // Save user data to controller
      registrationController.updateBasicInfo(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        city: "${cityController.text}, ${districtController.text}, ${stateController.text}",
      );

      // Navigate to gender selection screen
      Get.to(() => GenderSelectionScreen());
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
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
                "Let's Get Started",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'LoveDays',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Create an account to find your perfect match",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person_outline,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Basic Information Section
              CustomTextFieldWidget(
                editingController: nameController,
                labelText: "Full Name",
                iconData: Icons.person_outline,
                isObscure: false,
              ),
              const SizedBox(height: 16),
              CustomTextFieldWidget(
                editingController: emailController,
                labelText: "Email",
                iconData: Icons.email_outlined,
                isObscure: false,
              ),
              const SizedBox(height: 16),
              CustomTextFieldWidget(
                editingController: passwordController,
                labelText: "Password",
                iconData: Icons.lock_outline,
                isObscure: true,
              ),
              const SizedBox(height: 16),
              CustomTextFieldWidget(
                editingController: confirmPasswordController,
                labelText: "Confirm Password",
                iconData: Icons.lock_reset_outlined,
                isObscure: true,
              ),
              const SizedBox(height: 24),

              // Location Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: currentTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: currentTheme.colorScheme.primary,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: isFetchingLocation ? null : _getLocation,
                          icon: isFetchingLocation
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Icon(Icons.location_on_outlined, size: 20),

                          label: Text(
                            isFetchingLocation ? "Locating..." : "Use My Location",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentTheme.colorScheme.primary,
                            foregroundColor: currentTheme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Location fields
                    CustomTextFieldWidget(
                      editingController: cityController,
                      labelText: "City",
                      iconData: Icons.location_city_outlined,
                      isObscure: false,
                    ),
                    const SizedBox(height: 12),
                    CustomTextFieldWidget(
                      editingController: districtController,
                      labelText: "District",
                      iconData: Icons.map_outlined,
                      isObscure: false,
                    ),
                    const SizedBox(height: 12),
                    CustomTextFieldWidget(
                      editingController: stateController,
                      labelText: "State",
                      iconData: Icons.flag_outlined,
                      isObscure: false,
                    ),

                    if (currentLocationError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  currentLocationError!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Next button
              ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentTheme.colorScheme.primary,
                  foregroundColor: currentTheme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}