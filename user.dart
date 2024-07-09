import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/models/audio_book.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String profilePicture;
  final List<Book> purchasedBooks;
  final List<AudioBook> purchasedAudioBooks;
  final Map<String, int> lastOpenedPage;
  final Map<String, int> lastPlayedAudio;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePicture,
    this.purchasedBooks = const [],
    this.purchasedAudioBooks = const [],
    this.lastOpenedPage = const {},
    this.lastPlayedAudio = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      purchasedBooks: _convertDynamicListToBooks(json['purchasedBooks']),
      purchasedAudioBooks: _convertDynamicListToAudioBooks(json['purchasedAudioBooks']),
      lastOpenedPage: json['lastOpenedPage'] != null ? Map<String, int>.from(json['lastOpenedPage']) : {},
      lastPlayedAudio: json['lastPlayedAudio'] != null ? Map<String, int>.from(json['lastPlayedAudio']) : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'purchasedBooks': _convertBooksToDynamicList(purchasedBooks),
      'purchasedAudioBooks': _convertAudioBooksToDynamicList(purchasedAudioBooks),
      'lastOpenedPage': lastOpenedPage,
      'lastPlayedAudio': lastPlayedAudio,
    };
  }

  static List<Book> _convertDynamicListToBooks(dynamic books) {
    if (books == null) {
      return [];
    }
    return List<Book>.from(books.map((book) => Book.fromJson(book)));
  }

  static List<AudioBook> _convertDynamicListToAudioBooks(dynamic audioBooks) {
    if (audioBooks == null) {
      return [];
    }
    return List<AudioBook>.from(audioBooks.map((audioBook) => AudioBook.fromJson(audioBook)));
  }

  static List<Map<String, dynamic>> _convertBooksToDynamicList(List<Book> books) {
    return books.map((book) => book.toJson()).toList();
  }

  static List<Map<String, dynamic>> _convertAudioBooksToDynamicList(List<AudioBook> audioBooks) {
    return audioBooks.map((audioBook) => audioBook.toJson()).toList();
  }
}
