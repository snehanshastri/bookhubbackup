import 'package:flutter/material.dart';
import 'package:bookhubapp/widgets/reading_book.dart';
import 'package:bookhubapp/api/generated_books.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/widgets/book_cover_3d.dart';
import 'package:bookhubapp/auth_service.dart';
// Import your authentication service

class KeepReadingSection extends StatelessWidget {
  const KeepReadingSection({super.key});

  List<Book> getKeepReadingBooks() {
    final List<Book> books = getAllBooks();
    return books.where((book) => book.isPurchased && book.lastOpenPage > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Book> books = getKeepReadingBooks();
     bool userLoggedIn = AuthService.isLoggedIn(); 

    return userLoggedIn ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Keep Reading',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _buildKeepReadingBookList(context, books),
          ),
        ),
      ],
    ) : const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Text(
          'Please log in to see your books.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  List<Widget> _buildKeepReadingBookList(BuildContext context, List<Book> books) {
    return books.map((book) {
      return Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReadingBook(
                  pdfPath: "assets/harry_potter.pdf", // Make sure to replace this with the actual path
                ),
              ),
            );
          },
          child: BookCover3D(imageUrl: book.imageUrl),
        ),
      );
    }).toList();
  }
}
