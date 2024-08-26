import 'package:bookhubapp/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profileImageUrl;
  String? _userName;
  int _booksPurchased = 0;
  File? _image;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      List<dynamic> purchasedBooks = userDoc['purchasedBooks'] ?? [];
      List<dynamic> purchasedAudioBooks = userDoc['purchasedAudioBooks'] ?? [];

      setState(() {
        _profileImageUrl = userDoc['profilePicture'];
        _userName = userDoc['name'];
        _booksPurchased = purchasedBooks.length + purchasedAudioBooks.length;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String filePath = 'profile_pictures/${user.uid}.png';
      await FirebaseStorage.instance.ref(filePath).putFile(_image!);
      String downloadUrl = await FirebaseStorage.instance
          .ref(filePath)
          .getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilePicture': downloadUrl});

      setState(() {
        _profileImageUrl = downloadUrl;
      });
    } catch (e) {
      // Handle errors
      print(e);
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen()
                      ),
                    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have been logged out successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : const NetworkImage('https://via.placeholder.com/150'),
                child: _image == null ? const Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _userName ?? 'Loading...',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black45),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Books Purchased:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.black45),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_booksPurchased',
                    style: const TextStyle(fontSize: 24, color:Colors.black45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to buy a book page
                 Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen()
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Buy a Book'),
            ),
          ],
        ),
      ),
    );
  }
}
