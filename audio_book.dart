import 'package:cloud_firestore/cloud_firestore.dart';

class AudioBook {
  final String id;
  final String title;
  final String coverImage;
  final String genre;
  final String description;
  final double rating;
  final double price;
  String audioPath;

  AudioBook({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.genre,
    required this.description,
    required this.rating,
    required this.price,
    required this.audioPath,
  });

  // Convert an AudioBook object into a Map for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coverImage': coverImage,
      'genre': genre,
      'description': description,
      'rating': rating,
      'price': price,
      'audioPath': audioPath
    };
  }

  // Convert a Firestore Document Snapshot into an AudioBook object
  factory AudioBook.fromJson(Map<String, dynamic> json) {
  return AudioBook(
    id: json['id'] as String,
    title: json['title'] as String,
    coverImage: json['coverImage'] as String,
    genre: json['genre'] as String,
    description: json['description'] as String,
    rating: (json['rating'] as num).toDouble(),
    price: (json['price'] as num).toDouble(),
     audioPath: json['audioPath'] as String,
  );
}

}

// Function to upload audio books to Firestore
Future<void> uploadAudioBooks(List<AudioBook> audioBooks) async {
  final CollectionReference audioBooksCollection = FirebaseFirestore.instance.collection('audio_books');

  for (AudioBook audioBook in audioBooks) {
    final querySnapshot = await audioBooksCollection
        .where('id', isEqualTo: audioBook.id)
        .get();

    if (querySnapshot.docs.isEmpty) {
      await audioBooksCollection.doc(audioBook.id).set(audioBook.toJson());
    }
  }
}

// Function to fetch audio books from Firestore
Future<List<AudioBook>> fetchAudioBooks() async {
  final CollectionReference audioBooksCollection = FirebaseFirestore.instance.collection('audio_books');
  final QuerySnapshot querySnapshot = await audioBooksCollection.get();

  return querySnapshot.docs.map((doc) => AudioBook.fromJson(doc.data() as Map<String, dynamic>)).toList();
}

// Function to add audio books to Firestore
Future<void> addAudioBooksToFirestore(List<AudioBook> audioBooks) async {
  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore.collection('audio_books');

  for (var audioBook in audioBooks) {
    final querySnapshot = await collectionRef
        .where('title', isEqualTo: audioBook.title)
        .get();

    if (querySnapshot.docs.isEmpty) {
      await collectionRef.add(audioBook.toJson());
    }
  }
}
