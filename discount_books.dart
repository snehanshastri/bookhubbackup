import 'package:bookhubapp/auth_service.dart';
import 'package:bookhubapp/book_detail_screen.dart';
import 'package:bookhubapp/models/audio_book.dart';
import 'package:flutter/material.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/widgets/buy_book_wrapper.dart';
import 'package:bookhubapp/api/generated_books.dart';

class DiscountBooks extends StatelessWidget {
  const DiscountBooks({super.key, required void Function(BuildContext context, Book book) onBookTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Discount Books",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
    color: Colors.black,
        ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _buildDiscountBookList(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDiscountBookList(BuildContext context) {
    List<Book> books = getDiscountedBooks();

    return books.map((book) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(book: book, isLoggedIn: AuthService.isLoggedIn(), updateCart: (List<Book> books, List<AudioBook> audioBooks) {  },),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: BuyBookWrapper(book: book, titleStyle: const TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontFamily: 'Poppins',),
        ),
      ),
      );
    },
    ).toList();
  }
}
