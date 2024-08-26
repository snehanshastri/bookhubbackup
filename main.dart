import 'package:bookhubapp/api/generated_books.dart';
import 'package:bookhubapp/models/audio_book.dart';
import 'package:flutter/material.dart';
import 'package:bookhubapp/widgets/filter_row_section.dart';
import 'package:bookhubapp/discount_books.dart';
import 'package:bookhubapp/popular_books.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/widgets/search_bar.dart';
import 'package:bookhubapp/book_detail_screen.dart'; // Import your book detail screen file

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String searchQuery = '';
  List<Book> filteredBooks = [];

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredBooks = getAllBooks()
         .where((book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.authorName.toLowerCase().contains(query.toLowerCase()))
         .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    filteredBooks = getAllBooks(); // Initialize with all books
  }

  void goToBookDetails(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(book: book, isLoggedIn: true, updateCart: (List<Book> books, List<AudioBook> audioBooks) {  },),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MARKET",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarSection(onSearch: updateSearchQuery),
                  const SizedBox(height: 24),
                  const FilterRowSection(),
                  const SizedBox(height: 24),
                  if (searchQuery.isEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Popular Books",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        PopularBooks(onBookTap: (BuildContext context, Book book) {}),
                        const SizedBox(height: 24),
                        const Text(
                          "Discount Books",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        DiscountBooks(onBookTap: (BuildContext context, Book book) {}),
                      ],
                    ),
                  if (searchQuery.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Search Results",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            return ListTile(
                              leading: Image.network(book.imageUrl, width: 50, height: 50),
                              title: Text(
                                book.title,
                                style: const TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                book.authorName,
                                style: const TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                goToBookDetails(context, book); // Navigate to book detail screen
                              },
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
