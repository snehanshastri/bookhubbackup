import 'package:bookhubapp/cart.dart';
import 'package:bookhubapp/models/audio_book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookhubapp/auth_service.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/widgets/cartcontroller.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  final CartController cartController = Get.put(CartController());

  BookDetailScreen({
    Key? key,
    required this.book,
    required bool isLoggedIn,
    required Null Function(List<Book> books, List<AudioBook> audioBooks) updateCart,
  }) : super(key: key);

  void navigateToLoginPage(BuildContext context) {
    Get.toNamed('/login');
  }

  void addToCart(BuildContext context) {
    if (AuthService.isLoggedIn()) {
      if (cartController.isBookInCart(book)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${book.title} is already in the cart'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        cartController.addToCart(book);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${book.title} added to cart'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      navigateToLoginPage(context);
    }
  }

  void viewCart(BuildContext context) {
    Get.to(() => CartPage()); // Navigate to CartPage
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          book.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  book.imageUrl,
                  height: screenWidth * 0.5,
                  width: screenWidth * 0.4,
                ),
              ),
              SizedBox(height: 16),
              Text(
                book.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                'Price: ₹ ${book.price}',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 16),
              Text(
                book.description,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 16),
               Text(
                'Rating:  ${book.rating}',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('Add to Cart', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        viewCart(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('View Cart', style: TextStyle(fontSize: 18)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
