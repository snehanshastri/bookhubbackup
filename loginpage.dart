import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookhubapp/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:bookhubapp/home_screen.dart';
import 'signup_page.dart'; // Import the Signup page

class LoginPage extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool _isLoading = false.obs; // Use RxBool for reactive isLoading

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Login',
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(fontSize: 16.0),
                    border: const OutlineInputBorder(),
                    hoverColor: Colors.black.withOpacity(0.2),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
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
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity, // Set the width to infinity
                  child: ElevatedButton(
                    onPressed: _isLoading.value ? null : _login,
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
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity, // Set the width to infinity
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the Signup page using Get.to
                      Get.to(() => SignupPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('New User? Sign up here'),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true; // Set isLoading to true using RxBool
      try {
        String email = _emailController.text;
        String password = _passwordController.text;

        // Use GetX's `await` method to handle async operations
        User? user = await _auth.signInWithEmailAndPassword(email, password);
        if (user != null) {
          print("Login Successful");
          // Navigate to the HomeScreen using Get.off instead of Navigator.push
          Get.off(() => const HomeScreen());
        } else {
          // Handle case where user is null (shouldn't happen with correct implementation)
          print("Login failed");
        }
      } catch (e) {
        // Handle specific errors
        print("Error occurred during login: $e");
        // Display a snackbar or toast to inform the user
        Get.snackbar(
          "Login Error",
          "Login failed. Please check your credentials and try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        _isLoading.value = false; // Set isLoading to false using RxBool
      }
    }
  }
}
