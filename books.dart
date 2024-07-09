import 'package:cloud_firestore/cloud_firestore.dart';

enum Category {
  artAndLit,
  fiction,
  history,
  science,
  biography,
  business,
  children,
  comics,
  cooking,
  fantasy,
  health,
  mystery,
  philosophy,
  religion,
  romance,
  selfHelp,
  technology,
  travel,
  adventure,
  nonFiction,
  classic,
  scienceFiction,
}

String getCategoryString(Category category) {
  switch (category) {
    case Category.artAndLit:
      return "Art & Literature";
    case Category.fiction:
      return "Fiction";
    case Category.history:
      return "History";
    case Category.science:
      return "Science";
    case Category.biography:
      return "Biography";
    case Category.business:
      return "Business";
    case Category.children:
      return "Children";
    case Category.comics:
      return "Comics";
    case Category.cooking:
      return "Cooking";
    case Category.fantasy:
      return "Fantasy";
    case Category.health:
      return "Health";
    case Category.mystery:
      return "Mystery";
    case Category.philosophy:
      return "Philosophy";
    case Category.religion:
      return "Religion";
    case Category.romance:
      return "Romance";
    case Category.selfHelp:
      return "Self-Help";
    case Category.technology:
      return "Technology";
    case Category.travel:
      return "Travel";
    case Category.adventure:
      return "Adventure";
    case Category.nonFiction:
      return "Non-Fiction";
    case Category.classic:
      return "Classic";
    case Category.scienceFiction:
      return "Science Fiction";
    default:
      return "Unknown";
  }
}

class Book {
  String title;
  Category category;
  String isbn;
  double price;
  bool isFree;
  bool isPurchased;
  String description;
  double rating;
  int yearRelease;
  int pages;
  String authorName;
  String imageUrl;
  int lastOpenPage;
  int totalXP;
  String genre;
  String coverImage;
  bool isDiscounted;
  bool isPopular;
  String pdfPath; // New field for PDF path

  Book({
    required this.title,
    required this.category,
    required this.isbn,
    required this.price,
    required this.isFree,
    required this.isPurchased,
    required this.description,
    required this.rating,
    required this.yearRelease,
    required this.pages,
    required this.authorName,
    required this.imageUrl,
    required this.lastOpenPage,
    required this.totalXP,
    required this.genre,
    required this.coverImage,
    this.isDiscounted = false,
    this.isPopular = false,
    required this.pdfPath, // Initialize new field
  });

  // Convert a Book object into a Map for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category.toString().split('.').last, // Store category as string
      'isbn': isbn,
      'price': price,
      'isFree': isFree,
      'isPurchased': isPurchased,
      'description': description,
      'rating': rating,
      'yearRelease': yearRelease,
      'pages': pages,
      'authorName': authorName,
      'imageUrl': imageUrl,
      'lastOpenPage': lastOpenPage,
      'totalXP': totalXP,
      'genre': genre,
      'coverImage': coverImage,
      'isDiscounted': isDiscounted,
      'isPopular': isPopular,
      'pdfPath': pdfPath, // Include pdfPath in the JSON
    };
  }

  // Convert a Firestore Document Snapshot into a Book object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      category: Category.values.firstWhere((e) => e.toString() == 'Category.${json['category']}'),
      isbn: json['isbn'],
      price: json['price'],
      isFree: json['isFree'],
      isPurchased: json['isPurchased'],
      description: json['description'],
      rating: json['rating'],
      yearRelease: json['yearRelease'],
      pages: json['pages'],
      authorName: json['authorName'],
      imageUrl: json['imageUrl'],
      lastOpenPage: json['lastOpenPage'],
      totalXP: json['totalXP'],
      genre: json['genre'],
      coverImage: json['coverImage'],
      isDiscounted: json['isDiscounted'],
      isPopular: json['isPopular'],
      pdfPath: json['pdfPath'], // Initialize pdfPath from JSON
    );
  }
}

Future<void> uploadBooks(List<Book> books) async {
  final CollectionReference booksCollection = FirebaseFirestore.instance.collection('books');

  for (Book book in books) {
    final querySnapshot = await booksCollection
        .where('isbn', isEqualTo: book.isbn)
        .get();

    if (querySnapshot.docs.isEmpty) {
      await booksCollection.doc(book.isbn).set(book.toJson());
    }
  }
}

Future<List<Book>> fetchBooks() async {
  final CollectionReference booksCollection = FirebaseFirestore.instance.collection('books');
  final QuerySnapshot querySnapshot = await booksCollection.get();

  return querySnapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data != null) {
      return Book.fromJson({
        ...data,
        'pdfPath': data['pdfPath'], // Ensure pdfPath is included in the fetched data
      });
    } else {
      // Handle case where doc.data() is null (if needed)
      throw Exception('Document data was null');
    }
  }).toList();
}


