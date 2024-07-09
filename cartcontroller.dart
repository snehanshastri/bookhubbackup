import 'package:get/get.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/models/audio_book.dart';

class CartController extends GetxController {
  RxList<Book> _booksInCart = <Book>[].obs;
  RxList<AudioBook> _audioBooksInCart = <AudioBook>[].obs;

  List<Book> get booksInCart => _booksInCart.toList();
  List<AudioBook> get audioBooksInCart => _audioBooksInCart.toList();

  double get totalPrice {
    double total = 0;
    for (var book in _booksInCart) {
      total += book.price;
    }
    for (var audioBook in _audioBooksInCart) {
      total += audioBook.price;
    }
    return total;
  }

  void addToCart(Book book) {
    if (!isBookInCart(book)) {
      _booksInCart.add(book);
    }
  }

  void addToAudioCart(AudioBook audioBook) {
    if (!isAudioBookInCart(audioBook)) {
      _audioBooksInCart.add(audioBook);
    }
  }

  void removeFromCart(Book book) {
    _booksInCart.remove(book);
  }

  void removeFromAudioCart(AudioBook audioBook) {
    _audioBooksInCart.remove(audioBook);
  }

  void clearCart() {
    _booksInCart.clear();
    _audioBooksInCart.clear();
  }

  bool isBookInCart(Book book) {
    return _booksInCart.any((item) => item.isbn == book.isbn);
  }

  bool isAudioBookInCart(AudioBook audioBook) {
    return _audioBooksInCart.any((item) => item.id == audioBook.id);
  }
}
