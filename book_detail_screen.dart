import 'package:flutter/material.dart';
import 'package:bookhubapp/models/books.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          book.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            Text(
              book.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),
            ),
            Text(
              book.genre,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              book.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              'Price: ${book.price}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              'Rating: ${book.rating}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement Buy Now functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement Add to Cart functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white),
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
