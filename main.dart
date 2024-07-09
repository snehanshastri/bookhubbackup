import 'package:bookhubapp/book_detail_screen.dart';
import 'package:bookhubapp/cart.dart';
import 'package:bookhubapp/landingpage.dart';
import 'package:bookhubapp/loginpage.dart';
import 'package:bookhubapp/models/audio_book.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:bookhubapp/widgets/cartcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookhubapp/api/generated_books.dart';
import 'package:bookhubapp/auth_service.dart';
import 'package:bookhubapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBxuiUkqigdTkCLyJ3itOtwVmx92kL5WIE',
          appId: "1:704652166711:web:d637f496e9263053d821b2",
          messagingSenderId: "704652166711",
          projectId: "bookhubapp-ca543",
        ),
      );
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    // Upload books and audio books only if Firebase initialization is successful
    List<Book> books = getAllBooks();
    await uploadBooks(books);
    print("Books uploaded successfully");

    List<AudioBook> audioBooks = getAllAudioBooks();
    await addAudioBooksToFirestore(audioBooks);
    print("Audio books uploaded successfully");
  } catch (e) {
    print("Error initializing Firebase or uploading data: $e");
  }

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LandingPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(
          name: '/bookDetails',
          page: () => BookDetailScreen(
            book: Get.arguments['book'], // Pass the book object via Get.arguments
            isLoggedIn: AuthService.isLoggedIn(),
            updateCart: (List<Book> books, List<AudioBook> audioBooks) {},
          ),
          binding: BindingsBuilder(() {
            Get.put(AuthService());
            Get.put(CartController());
          }),
        ),
        GetPage(
          name: '/cart',
          page: () => CartPage(),
          binding: BindingsBuilder(() {
            Get.put(CartController());
          }),
        ),
      ],
      unknownRoute: GetPage(
        name: '/unknown',
        page: () => const UnknownRouteScreen(),
      ),
    );
  }
}

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown Route'),
      ),
      body: const Center(
        child: Text('Unknown Route'),
      ),
    );
  }
}
