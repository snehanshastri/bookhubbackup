import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bookhubapp/app_theme.dart';
import 'package:bookhubapp/landingpage.dart'; // Import LandingPage

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startDelayTimer();
  }

  void _startDelayTimer() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Hub',
      theme: customTheme,
      home: Scaffold(
        body: _isLoading ? _buildLoadingScreen() : const LandingPage(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Image.asset(
        'assets/loader.gif',
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
