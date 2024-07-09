import 'package:bookhubapp/auth_service.dart';
import 'package:bookhubapp/widgets/reading_book.dart';
import 'package:bookhubapp/widgets/book_cover_3d.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LastOpenedBook extends StatelessWidget {
  const LastOpenedBook({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> _fetchLastOpenedBook() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      return null;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      return data?['lastOpenedBook'];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool userLoggedIn = AuthService.isLoggedIn();

    return userLoggedIn
        ? FutureBuilder<Map<String, dynamic>?>(
            future: _fetchLastOpenedBook(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching data'));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text(
                      'No last opened book found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }

              var lastOpenedBook = snapshot.data!;
              String pdfPath = lastOpenedBook['pdfPath'] ?? '';
              String imageUrl = lastOpenedBook['imageUrl'] ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReadingBook(
                                    pdfPath: pdfPath,
                                  )),
                        );
                      },
                      child: BookCover3D(
                        imageUrl: imageUrl,
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        : const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Text(
                'Please log in to see your last opened book.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
  }
}
