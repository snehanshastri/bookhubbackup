import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/models/audio_book.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Book>> getPurchasedBooks(String userId) async {
    List<Book> books = [];
    QuerySnapshot snapshot = await _firestore.collection('users')
        .doc(userId)
        .collection('purchasedBooks')
        .get();

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String pdfPath = await _storage.ref(data['pdfPath']).getDownloadURL();
      books.add(Book(
        title: data['title'],
        authorName: data['authorName'],
        price: data['price'],
        imageUrl: data['imageUrl'],
        pdfPath: pdfPath, category: data['category'], isbn: data['isbn'], isFree: data['isFree'], isPurchased: data['isPurchased'], description: data['description'], yearRelease: data['yearRelease'], rating: data['rating'], pages: data['pages'], lastOpenPage: data['lastOpenPage'], totalXP: data['totalXP'], genre: data['genre'], coverImage: data['coverImage'],
      ));
    }
    return books;
  }

  Future<List<AudioBook>> getPurchasedAudioBooks(String userId) async {
    List<AudioBook> audioBooks = [];
    QuerySnapshot snapshot = await _firestore.collection('users')
        .doc(userId)
        .collection('purchasedAudioBooks')
        .get();

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String audioUrl = await _storage.ref(data['audioPath']).getDownloadURL();
      audioBooks.add(AudioBook(
        title: data['title'],
        price: data['price'],
        coverImage: data['coverImage'],
        audioPath: audioUrl, id: data['id'], genre: data['genre'], description: data['description'], rating: data['rating'],
      ));
    }
    return audioBooks;
  }
}
