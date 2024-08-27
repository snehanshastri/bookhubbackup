import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show File;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadingBook extends StatefulWidget {
  final String gsPath;

  const ReadingBook({super.key, required this.gsPath});

  @override
  _ReadingBookState createState() => _ReadingBookState();
}

class _ReadingBookState extends State<ReadingBook> {
  String? filePath;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(widget.gsPath);
      final url = await ref.getDownloadURL();
      print('Download URL: $url');

      if (kIsWeb) {
        setState(() {
          filePath = url;
        });
      } else {
        final prefs = await SharedPreferences.getInstance();
        final savedFilePath = prefs.getString(widget.gsPath);
        if (savedFilePath != null && await File(savedFilePath).exists()) {
          setState(() {
            filePath = savedFilePath;
          });
        } else {
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/temp.pdf');
          if (await file.exists()) {
            setState(() {
              filePath = file.path;
            });
          } else {
            final response = await http.get(Uri.parse(url));
            if (response.statusCode == 200) {
              final bytes = response.bodyBytes;
              await file.writeAsBytes(bytes, flush: true);
              await prefs.setString(widget.gsPath, file.path);
              setState(() {
                filePath = file.path;
              });
            } else {
              throw Exception('Failed to download file');
            }
          }
        }
      }
    } catch (e) {
      print('Error initializing PDF: $e');
      setState(() {
        errorMessage = 'Failed to load the book. Please try again later.';
      });
    }
  }

  void _openPdfInNewTab(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      setState(() {
        errorMessage = 'Could not launch PDF viewer';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reading Book',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: errorMessage != null
          ? Center(child: Text(errorMessage!))
          : filePath == null
              ? const Center(child: CircularProgressIndicator())
              : kIsWeb
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => _openPdfInNewTab(filePath!),
                            child: const Text('Open in new tab', style: TextStyle(fontSize: 18))
                          ),
                        ],
                      ),
                    )
                  : SfPdfViewer.file(
                      File(filePath!),
                      canShowPaginationDialog: true,
                      pageSpacing: 2.0,
                    ),
    );
  }
}
