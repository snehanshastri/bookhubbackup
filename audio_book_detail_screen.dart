import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookhubapp/models/audio_book.dart';
import 'package:bookhubapp/loginpage.dart';
import 'package:bookhubapp/cart.dart';
import 'package:bookhubapp/auth_service.dart';
import 'package:bookhubapp/widgets/cartcontroller.dart';

class AudioBookDetailScreen extends StatelessWidget {
  final AudioBook audioBook;
  final CartController cartController = Get.put(CartController()); // Get the CartController instance
  final bool isLoggedIn = AuthService.isLoggedIn(); // Check if user is logged in

  AudioBookDetailScreen({
    super.key,
    required this.audioBook,
    required bool isLoggedIn,
  });

  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void addToCartAction(BuildContext context) {
    if (isLoggedIn) {
      if (cartController.isAudioBookInCart(audioBook)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${audioBook.title} is already in the cart'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        cartController.addToAudioCart(audioBook);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${audioBook.title} added to cart'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      navigateToLoginPage(context);
    }
  }

  void viewCart(BuildContext context) {
    final user = AuthService.currentUser;
    Get.to(() => CartPage(firebaseUser: user)); // Navigate to CartPage
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(audioBook.title, style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                audioBook.coverImage,
                height: screenWidth * 0.5,
                width: screenWidth * 0.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              audioBook.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
            ),
            Text(
              audioBook.genre,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              audioBook.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              'Price: ₹ ${audioBook.price}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              'Rating: ${audioBook.rating}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => addToCartAction(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => viewCart(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'View Cart',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
