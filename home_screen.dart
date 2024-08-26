import 'package:bookhubapp/all_purchased_books.dart';
import 'package:bookhubapp/api/generated_books.dart';
import 'package:bookhubapp/auth_service.dart';
import 'package:bookhubapp/book_detail_screen.dart';
import 'package:bookhubapp/loginpage.dart';
import 'package:bookhubapp/models/audio_book.dart';
import 'package:bookhubapp/profile.dart';
import 'package:bookhubapp/userslistpage.dart';
import 'package:flutter/material.dart';
import 'package:bookhubapp/popular_books.dart';
import 'package:bookhubapp/discount_books.dart';
import 'package:bookhubapp/widgets/audiobooks.dart';
import 'package:bookhubapp/models/books.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool isLoggedIn = AuthService.isLoggedIn();
  String searchQuery = '';
  List<Book> filteredBooks = [];

  void navigate(BuildContext context, String route) {
    if (isLoggedIn) {
      Navigator.pushNamed(context, route);
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }

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
    filteredBooks = getAllBooks();
  }

  void goToBookDetails(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(
          book: book,
          isLoggedIn: AuthService.isLoggedIn(),
          updateCart: (List<Book> books, List<AudioBook> audioBooks) {
            // Implement your update cart logic here
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Hub",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  onChanged: updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (searchQuery.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Search Results",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
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
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          subtitle: Text(
                            book.authorName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          onTap: () {
                            goToBookDetails(context, book);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              const Text(
                "Your Books",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              isLoggedIn ? const AllPurchasedBooks() : const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Text(
                    'Please log in to see your books.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              // const Text(
              //   "Keep Reading",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //     fontFamily: 'Poppins',
              //   ),
              // ),
              const SizedBox(height: 10),
              //const KeepReadingSection(),
              const SizedBox(height: 20),
              const Text(
                "Market",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 5),
              PopularBooks(onBookTap: goToBookDetails),
              const SizedBox(height: 20),
              DiscountBooks(onBookTap: goToBookDetails),
              const SizedBox(height: 20),
              const Text(
                "Audio Books",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 2),
              const AudioBooks(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.message, color: Colors.white),
              onPressed: () {
                if (isLoggedIn) {
                  final currentuser = AuthService.currentUser;
                  if (currentuser != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersListPage()
                      ),
                    );
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                }
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.notifications, color: Colors.white),
            //   onPressed: () {
            //     if (isLoggedIn) {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => NotificationsPage(),
            //         ),
            //       );
            //     } else {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => LoginPage(),
            //         ),
            //       );
            //     }
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                if (isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
