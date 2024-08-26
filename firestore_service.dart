import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookhubapp/models/audio_book.dart'; // Import your AudioBook class
import 'package:bookhubapp/models/books.dart';// Import your Book class

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addAudioBook(AudioBook audioBook, int count) async {
    await _db.collection('audiobooks').add({
      'title': audioBook.title,
      'coverImage': audioBook.coverImage,
      'genre': audioBook.genre,
      'description': audioBook.description,
      'rating': audioBook.rating,
      'price': audioBook.price,
      'count': count,
    });
  }

  Future<List<AudioBook>> getAudioBooks() async {
    var snapshot = await _db.collection('audiobooks').get();
    return snapshot.docs.map((doc) => AudioBook(
      
      title: doc['title'],
      coverImage: doc['coverImage'],
      genre: doc['genre'],
      description: doc['description'],
      rating: doc['rating'],
      price: doc['price'], id: doc['id'], audioPath: doc['audioPath']

    )).toList();
  }

  Future<void> updateAudioBookCount(String docId, int count) async {
    await _db.collection('audiobooks').doc(docId).update({'count': count});
  }

  Future<void> decrementAudioBookCount(String docId) async {
    var doc = await _db.collection('audiobooks').doc(docId).get();
    int currentCount = doc['count'];
    if (currentCount > 0) {
      await updateAudioBookCount(docId, currentCount - 1);
    }
  }

  Future<void> addBook(Book book, int count) async {
    await _db.collection('books').add({
      'title': book.title,
      'coverImage': book.coverImage,
      'genre': book.genre,
      'description': book.description,
      'rating': book.rating,
      'price': book.price,
      'count': count,
    });
  }

  Future<List<Book>> getBooks() async {
    var snapshot = await _db.collection('books').get();
    return snapshot.docs.map((doc) => Book(
      title: doc['title'],
      coverImage: doc['coverImage'],
      genre: doc['genre'],
      description: doc['description'],
      rating: doc['rating'],
      price: doc['price'], category: doc['category'], isbn: doc['isbn'], isFree: doc['isFree'], isPurchased: doc['isPurchased'], yearRelease: doc['yearRelease'], pages: doc['pages'], authorName: doc['authorName'], imageUrl: doc['imageUrl'], lastOpenPage: doc['lastOpenPage'], totalXP: doc['totalXP'], pdfPath: doc['pdfPath'],
      
    )).toList();
  }

  Future<void> updateBookCount(String docId, int count) async {
    await _db.collection('books').doc(docId).update({'count': count});
  }

  Future<void> decrementBookCount(String docId) async {
    var doc = await _db.collection('books').doc(docId).get();
    int currentCount = doc['count'];
    if (currentCount > 0) {
      await updateBookCount(docId, currentCount - 1);
    }
  }
}
