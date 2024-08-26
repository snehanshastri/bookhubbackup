import 'package:flutter/material.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/models/audio_book.dart';
import 'package:bookhubapp/widgets/book_cover_3d.dart';
import 'package:bookhubapp/widgets/reading_book.dart';
import 'package:bookhubapp/audio_book_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookhubapp/firebase_auth_implementation/dataservices.dart';

class AllPurchasedBooks extends StatelessWidget {
  const AllPurchasedBooks({super.key});

  Future<List<Book>> _fetchPurchasedBooks() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Fetching purchased books for user: ${user.uid}");
      var books = await DataService().getPurchasedBooks(user.uid);
      print("Fetched books: $books");
      return books;
    }
    print("No user logged in");
    return [];
  }

  Future<List<AudioBook>> _fetchPurchasedAudioBooks() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Fetching purchased audiobooks for user: ${user.uid}");
      var audioBooks = await DataService().getPurchasedAudioBooks(user.uid);
      print("Fetched audiobooks: $audioBooks");
      return audioBooks;
    }
    print("No user logged in");
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Your Purchased Books and Audiobooks",
        //   style: Theme.of(context).textTheme.titleLarge, 
        // ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FutureBuilder<List<Book>>(
                future: _fetchPurchasedBooks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    var books = snapshot.data!;
                    print("Books data: $books");
                    if (books.isEmpty) {
                      return const Text("No purchased books available.");
                    }
                    return Row(
                      children: books.map((book) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadingBook(gsPath: book.pdfPath),
                                ),
                              );
                            },
                            child: BookCover3D(imageUrl: book.imageUrl),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const Text("No purchased books available.");
                },
              ),
              FutureBuilder<List<AudioBook>>(
                future: _fetchPurchasedAudioBooks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    var audioBooks = snapshot.data!;
                    print("Audiobooks data: $audioBooks");
                    if (audioBooks.isEmpty) {
                      return const Text("No purchased audiobooks available.");
                    }
                    return Row(
                      children: audioBooks.map((audioBook) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AudioBookPlayer( audioBookTitle: audioBook.title,),
                                ),
                              );
                            },
                            child: BookCover3D(imageUrl: audioBook.coverImage),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const Text("No purchased audiobooks available.");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
