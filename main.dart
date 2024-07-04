import 'package:flutter/material.dart';
import 'package:bookhubapp/book_detail_screen.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/landingpage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/bookDetails') {
          final book = settings.arguments as Book;
          return MaterialPageRoute(
            builder: (context) {
              return BookDetailScreen(book: book);
            },
          );
        }
        return null;
      },
    );
  }
}
