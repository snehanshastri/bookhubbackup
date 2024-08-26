import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookhubapp/models/audio_book.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/models/user.dart';

class PaymentPage extends StatefulWidget {
  final List<Book> cartBooks;
  final List<AudioBook> cartAudioBooks;
  final User user;
  final Function onSuccess;

  const PaymentPage({
    super.key,
    required this.cartBooks,
    required this.cartAudioBooks,
    required this.user,
    required this.onSuccess,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double calculateTotalPrice() {
    double total = 0.0;

    for (var book in widget.cartBooks) {
      if (!widget.user.purchasedBooks.any((purchasedBook) => purchasedBook.isbn == book.isbn)) {
        total += book.price;
      }
    }

    for (var audioBook in widget.cartAudioBooks) {
      if (!widget.user.purchasedAudioBooks.any((purchasedAudioBook) => purchasedAudioBook.id == audioBook.id)) {
        total += audioBook.price;
      }
    }

    return total;
  }

  Future<void> handlePayment() async {
    double totalPrice = calculateTotalPrice();

    if (totalPrice == 0) {
      // Show dialog for no new purchases
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No New Purchases'),
          content: const Text('All items in your cart are already purchased.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (widget.user.bankBalance >= totalPrice) {
      setState(() {
        widget.user.bankBalance -= totalPrice;

        // Mark books as purchased and add to user's purchased list
        for (var book in widget.cartBooks) {
          if (!widget.user.purchasedBooks.any((purchasedBook) => purchasedBook.isbn == book.isbn)) {
            book.isPurchased = true;
            widget.user.purchasedBooks.add(book);
          }
        }

        // Mark audio books as purchased and add to user's purchased list
        for (var audioBook in widget.cartAudioBooks) {
          if (!widget.user.purchasedAudioBooks.any((purchasedAudioBook) => purchasedAudioBook.id == audioBook.id)) {
            audioBook.isPurchased = true;
            widget.user.purchasedAudioBooks.add(audioBook);
          }
        }
      });

      // Update Firestore with new bank balance and purchased books/audiobooks
      try {
        await _firestore.collection('users').doc(widget.user.uid).update({
          'bankBalance': widget.user.bankBalance,
          'purchasedBooks': widget.user.purchasedBooks.map((book) => book.toMap()).toList(),
          'purchasedAudioBooks': widget.user.purchasedAudioBooks.map((audioBook) => audioBook.toMap()).toList(),
        });

        // Call onSuccess callback to handle post-purchase actions
        widget.onSuccess();
      } catch (e) {
        // Handle error updating Firestore
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred while updating your purchase. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Show dialog for insufficient balance
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Insufficient Balance'),
          content: const Text('You do not have enough balance to complete this purchase.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    double originalTotalPrice = widget.cartBooks.fold<double>(0.0, (sum, book) => sum + book.price) + widget.cartAudioBooks.fold<double>(0.0, (sum, audioBook) => sum + audioBook.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Original Total Price: ₹${originalTotalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Total Price after Removing Purchased Items: ₹${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: handlePayment,
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }
}

extension on Book {
  Map<String, dynamic> toMap() {
    return {
      'isbn': isbn,
      'title': title,
      'authorName': authorName,
      'price': price,
      'isPurchased': isPurchased,
      'category': category.toString().split('.').last, // Store category as string
      'isFree': isFree,
      'description': description,
      'rating': rating,
      'yearRelease': yearRelease,
      'pages': pages,
      'imageUrl': imageUrl,
      'lastOpenPage': lastOpenPage,
      'totalXP': totalXP,
      'genre': genre,
      'coverImage': coverImage,
      'isDiscounted': isDiscounted,
      'isPopular': isPopular,
      'pdfPath': pdfPath
      // Add other fields as necessary
    };
  }
}

extension on AudioBook {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'isPurchased': isPurchased,
      'coverImage': coverImage,
      'genre': genre,
      'description': description,
      'rating': rating,
      'audioPath': audioPath,
      // Add other fields as necessary
    };
  }
}
