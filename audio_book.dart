import 'package:cloud_firestore/cloud_firestore.dart';

class AudioBook {
  final String id;
  final String title;
  final String coverImage;
  final String genre;
  final String description;
  final double rating;
  final double price;
  final String audioPath;
  bool isPurchased;

  AudioBook({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.genre,
    required this.description,
    required this.rating,
    required this.price,
    required this.audioPath,
    this.isPurchased = false,
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
      'audioPath': audioPath,
      'isPurchased': isPurchased,
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
      isPurchased: json['isPurchased'] as bool? ?? false,
    );
  }

  // CopyWith method
  AudioBook copyWith({
    String? id,
    String? title,
    String? coverImage,
    String? genre,
    String? description,
    double? rating,
    double? price,
    String? audioPath,
    bool? isPurchased,
  }) {
    return AudioBook(
      id: id ?? this.id,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      audioPath: audioPath ?? this.audioPath,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}

Future<void> uploadAudioBooks(List<AudioBook> audioBooks) async {
  final CollectionReference audioBooksCollection = FirebaseFirestore.instance.collection('audio_books');

  for (AudioBook audioBook in audioBooks) {
    final querySnapshot = await audioBooksCollection
        .where('title', isEqualTo: audioBook.title)
        .get();

    if (querySnapshot.docs.isEmpty) {
      await audioBooksCollection.doc(audioBook.id).set(audioBook.toJson());
    }
  }
}
