import 'package:flutter/material.dart';
import 'package:bookhubapp/widgets/reading_book.dart';
import 'package:bookhubapp/api/generated_books.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/widgets/book_cover_3d.dart';

class KeepReadingSection extends StatelessWidget {
  const KeepReadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _buildPopularBookList(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPopularBookList(BuildContext context) {
    final List<Book> books = getAllBooks();

    return books.skip(12).take(5).map((book) {
      return Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReadingBook(
                  pdfPath: "assets/harry_potter.pdf",
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