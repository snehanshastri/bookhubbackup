import 'package:flutter/material.dart';
import 'package:bookhubapp/api/generated_books.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/widgets/book_cover_3d.dart';
import 'package:bookhubapp/widgets/reading_book.dart';

class AllPurchasedBooks extends StatelessWidget {
  const AllPurchasedBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Waiting for you",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _buildPurchasedBookList(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPurchasedBookList(BuildContext context) {
    List<Book> books = getBooksByPurchased();

    return books.map((book) {
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