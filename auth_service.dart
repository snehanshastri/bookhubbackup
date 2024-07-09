import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  static String getCurrentUserId() {
    return _auth.currentUser?.uid ?? '';
  }

  // Add more authentication methods if needed
}
