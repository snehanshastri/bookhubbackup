import 'package:flutter/material.dart';
import 'package:bookhubapp/models/audio_book.dart'; // Ensure you have an AudioBook model

class AudioBookDetailScreen extends StatelessWidget {
  final AudioBook audioBook;

  const AudioBookDetailScreen({super.key, required this.audioBook});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(audioBook.title, style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black), // Change app bar icon color
        backgroundColor: Colors.white, // Change app bar background color if needed
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),
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
              'Price: ${audioBook.price}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              'Rating: ${audioBook.rating}',
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
                      foregroundColor: Colors.white, backgroundColor: Colors.black, // Button text color
                    ),
                    child: const Text('Buy Now'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement Add to Cart functionality
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.black, // Button text color
                    ),
                    child: const Text('Add to Cart'),
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
