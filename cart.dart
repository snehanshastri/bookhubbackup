import 'package:bookhubapp/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:bookhubapp/widgets/cartcontroller.dart';
import 'package:bookhubapp/paymentpage.dart'; // Import your payment page here
import 'package:bookhubapp/home_screen.dart'; // Import your home screen page here
import 'package:bookhubapp/models/user.dart'; // Import your user model here
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find();
  final auth.User? firebaseUser;

  CartPage({super.key, required this.firebaseUser});

  void proceedToPayment(BuildContext context, User user) {
    if (cartController.booksInCart.isEmpty && cartController.audioBooksInCart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cart is empty. Add items to proceed.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Get.to(() => PaymentPage(
      cartBooks: cartController.booksInCart,
      cartAudioBooks: cartController.audioBooksInCart,
      user: user, // Pass the custom user object
      onSuccess: () {
        // Navigate to home screen after successful payment
        Get.offAll(() => const HomeScreen());
      },
    ));
  }

  void viewCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cart Items'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Books in Cart:'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartController.booksInCart.length,
                  itemBuilder: (context, index) {
                    final book = cartController.booksInCart[index];
                    return ListTile(
                      title: Text(book.title),
                      subtitle: Text('₹${book.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cartController.removeFromCart(book);
                          Navigator.pop(context); // Close the dialog after deletion
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text('Audio Books in Cart:'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartController.audioBooksInCart.length,
                  itemBuilder: (context, index) {
                    final audioBook = cartController.audioBooksInCart[index];
                    return ListTile(
                      title: Text(audioBook.title),
                      subtitle: Text('₹${audioBook.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cartController.removeFromAudioCart(audioBook);
                          Navigator.pop(context); // Close the dialog after deletion
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: AuthService().fetchUserData(firebaseUser!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('User data not available'));
        }

        final customUser = snapshot.data!;

        double totalPrice = cartController.totalPrice;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Cart',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartController.booksInCart.length + cartController.audioBooksInCart.length,
                    itemBuilder: (context, index) {
                      if (index < cartController.booksInCart.length) {
                        final book = cartController.booksInCart[index];
                        return ListTile(
                          title: Text(book.title),
                          subtitle: Text('₹${book.price}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartController.removeFromCart(book);
                            },
                          ),
                        );
                      } else {
                        int audioIndex = index - cartController.booksInCart.length;
                        final audioBook = cartController.audioBooksInCart[audioIndex];
                        return ListTile(
                          title: Text(audioBook.title),
                          subtitle: Text('₹${audioBook.price}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartController.removeFromAudioCart(audioBook);
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(), // Add a divider for visual separation
                const SizedBox(height: 16),
                // ElevatedButton(
                //   onPressed: () {
                //     viewCart(context); // Call the view cart function
                //   },
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                //     child: Text('View Cart', style: TextStyle(fontSize: 16)),
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     foregroundColor: Colors.white, backgroundColor: Colors.black,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30.0),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal: ₹$totalPrice',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        proceedToPayment(context, customUser);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Proceed', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
