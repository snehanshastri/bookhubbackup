import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bookhubapp/models/audio_book.dart';

class AudioBookPlayer extends StatefulWidget {
  final String audioBookTitle;

  const AudioBookPlayer({super.key, required this.audioBookTitle});

  @override
  _AudioBookPlayerState createState() => _AudioBookPlayerState();
}

class _AudioBookPlayerState extends State<AudioBookPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentStatus = 'Stopped';
  AudioBook? audioBook;
  bool isLoading = true;
  String? errorMessage;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchAudioBookFromDatabase(widget.audioBookTitle);
  }

  Future<void> _fetchAudioBookFromDatabase(String audioBookTitle) async {
    try {
      // Print the title being queried for debugging
      print('Fetching audio book with title: $audioBookTitle');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('audio_books')
              .where('title', isEqualTo: audioBookTitle)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> audioBookSnapshot = querySnapshot.docs.first;
        final audioBook = AudioBook.fromJson(audioBookSnapshot.data()!);

        // Convert gs:// URL to HTTP URL
        final storageRef = FirebaseStorage.instance.refFromURL(audioBook.audioPath);
        final audioUrl = await storageRef.getDownloadURL();

        setState(() {
          this.audioBook = audioBook.copyWith(audioPath: audioUrl);
          isLoading = false;
        });
      } else {
        print('Audio book not found in database for title: $audioBookTitle');
        setState(() {
          errorMessage = 'Audio book not found.';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching audio book: $e');
      setState(() {
        errorMessage = 'Failed to fetch audio book. Please try again later.';
        isLoading = false;
      });
    }
  }

  Future<void> _playAudio() async {
    if (audioBook != null) {
      try {
        await _audioPlayer.play(UrlSource(audioBook!.audioPath));
        setState(() {
          isPlaying = true;
          currentStatus = 'Playing';
        });
      } catch (e) {
        setState(() {
          currentStatus = 'Error playing audio';
        });
        print('Error playing audio: $e');
      }
    } else {
      setState(() {
        currentStatus = 'No audio book loaded';
      });
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
        currentStatus = 'Paused';
      });
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        isPlaying = false;
        currentStatus = 'Stopped';
      });
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(audioBook?.title ?? 'Loading...'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Audio Book Player',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      Text('Title: ${audioBook!.title}'),
                      Text('Genre: ${audioBook!.genre}'),
                      const SizedBox(height: 20),
                      Text('Status: $currentStatus'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (isPlaying) {
                            _pauseAudio();
                          } else {
                            _playAudio();
                          }
                        },
                        child: Text(isPlaying ? 'Pause' : 'Play'),
                      ),
                      ElevatedButton(
                        onPressed: _stopAudio,
                        child: const Text('Stop'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
