import 'package:bookhubapp/models/audio_book.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Book>> getPurchasedBooks(String userId) async {
    try {
      var userDoc = await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        var purchasedBooks = userDoc.data()?['purchasedBooks'] as List<dynamic>? ?? [];
        return purchasedBooks.map((bookData) => Book.fromJson(bookData)).toList();
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching purchased books: $e');
    }
    return [];
  }

  Future<List<AudioBook>> getPurchasedAudioBooks(String userId) async {
    try {
      var userDoc = await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        var purchasedAudioBooks = userDoc.data()?['purchasedAudioBooks'] as List<dynamic>? ?? [];
        return purchasedAudioBooks.map((audioBookData) => AudioBook.fromJson(audioBookData)).toList();
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching purchased audiobooks: $e');
    }
    return [];
  }
}
