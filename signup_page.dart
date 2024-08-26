import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookhubapp/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:bookhubapp/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore dependencies
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias Firebase Auth User class

class SignupPage extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool _isLoading = false.obs;

  SignupPage({super.key}); // Use RxBool for reactive isLoading

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _balanceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Sign up',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0.0, // Remove the app bar shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min, // Take up only the space needed
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(fontSize: 16.0),
                    border: const OutlineInputBorder(),
                    hoverColor: Colors.black.withOpacity(0.2),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(fontSize: 16.0),
                    border: const OutlineInputBorder(),
                    hoverColor: Colors.black.withOpacity(0.2),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(fontSize: 16.0),
                    border: const OutlineInputBorder(),
                    hoverColor: Colors.black.withOpacity(0.2),
                  ),
                  obscureText: true, // Hide the password input
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Please enter a password with at least 8 characters';
                    }
                    String pattern = r'^(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a password with at least one number and one special character';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _balanceController,
                  decoration: InputDecoration(
                    labelText: 'Initial Balance',
                    labelStyle: const TextStyle(fontSize: 16.0),
                    border: const OutlineInputBorder(),
                    hoverColor: Colors.black.withOpacity(0.2),
                  ),
                  keyboardType: TextInputType.number, // Numeric input for balance
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your initial balance';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity, // Set the width to infinity
                  child: ElevatedButton(
                    onPressed: _isLoading.value ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: _isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Sign up'),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true; // Set isLoading to true using RxBool
      try {
        String name = _nameController.text;
        String email = _emailController.text;
        String password = _passwordController.text;
        double balance = double.parse(_balanceController.text);

        // Call your authentication service for signup
        firebase_auth.User? user = await _auth.signUpWithEmailAndPassword(email, password);

        if (user != null) {
          // Add user details to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': name,
            'email': email,
            'bankBalance': balance, // Add initial balance
            'profilePicture': '', // Add default or uploaded profile picture URL here
            'purchasedBooks': [],
            'purchasedAudioBooks': [],
            'lastOpenedPage': {},
            'lastPlayedAudio': {},
          });

          print("Sign Up Successful");
          Get.off(() => const HomeScreen()); // Navigate to HomeScreen using Get.off
        } else {
          print("Sign Up Failed");
        }
      } catch (e) {
        // Handle errors that might occur during the signup process
        print("Error occurred during signup: $e");
        Get.snackbar(
          "Signup Error",
          "Signup failed. Please check your details and try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        _isLoading.value = false; // Set isLoading to false using RxBool
      }
    }
  }
}
