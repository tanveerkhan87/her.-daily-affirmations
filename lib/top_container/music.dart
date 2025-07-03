import 'dart:async'; // We need this for the StreamSubscription
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

// --- Data Model ---
// A simple class to hold all the info for one song.
// This keeps the main code much cleaner.
class Song {
  final String path;
  final String title;
  final String image;

  const Song({required this.path, required this.title, required this.image});
}

// --- Centralized List of All Songs ---
// To add, remove, or change a song, you only need to edit this list.
final List<Song> allSongs = [
  const Song(path: 'assets/sounds/peace.mp3', title: 'Peace', image: 'assets/images/bg9.jpg'),
  const Song(path: 'assets/sounds/alone.mp3', title: 'Alone', image: 'assets/images/bg2.jpg'),
  const Song(path: 'assets/sounds/nature.mp3', title: 'Nature', image: 'assets/images/bg7.jpg'),
  const Song(path: 'assets/sounds/night.mp3', title: 'Night', image: 'assets/images/bg13.jpg'),
  const Song(path: 'assets/sounds/colors.mp3', title: 'Colors', image: 'assets/images/bg15.jpg'),
];

// --- Simplified Audio Service ---
// A collection of simple functions to control the audio player.
class AudioService {
  // We create one single player for the whole app.
  static final AudioPlayer player = AudioPlayer();

  // A simple function to load a new song.
  static Future<void> setSong(String assetPath) async {
    try {
      await player.setAsset(assetPath);
    } catch (e) {
      debugPrint("Error loading audio source: $e");
    }
  }

  // Simple controls that just call the player's functions.
  static void play() => player.play();
  static void pause() => player.pause();
  static void stop() => player.stop();
  static void seek(Duration position) => player.seek(position);
}


class MusicPlayerBottomSheet extends StatefulWidget {
  const MusicPlayerBottomSheet({super.key});

  @override
  _MusicPlayerBottomSheetState createState() => _MusicPlayerBottomSheetState();
}

class _MusicPlayerBottomSheetState extends State<MusicPlayerBottomSheet> {
  // --- State Variables ---
  // These variables hold the current state of our widget.

  // The song that is currently loaded or playing.
  late Song _currentSong;

  // A boolean to track if the music is playing. We will update this manually.
  bool _isPlaying = false;

  // This will hold our subscription to the player's state changes.
  late StreamSubscription<PlayerState> _playerStateSubscription;


  @override
  void initState() {
    super.initState();
    // When the widget is first created:

    // 1. Set the initial song to be the first one in our list.
    _currentSong = allSongs.first;
    AudioService.setSong(_currentSong.path);

    // 2. Set up a listener. This is the key part!
    // This code will run WHENEVER the player's state changes (play, pause, stop, complete).
    _playerStateSubscription = AudioService.player.playerStateStream.listen((state) {
      if (mounted) { // Check if the widget is still on screen
        setState(() {
          // Update our local _isPlaying variable based on the player's actual state.
          _isPlaying = state.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    // This is very important! When the widget is removed, we must cancel the subscription
    // to avoid memory leaks. We also stop the music.
    _playerStateSubscription.cancel();
    AudioService.stop();
    super.dispose();
  }

  /// This function is called when a user taps on a new song from the list.
  void _selectSong(Song newSong) {
    setState(() {
      _currentSong = newSong;
    });
    AudioService.setSong(newSong.path);
    AudioService.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Her.", style: GoogleFonts.montserratAlternates(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.pink)),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.cancel)),
                ],
              ),
            ),

            // Player UI Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                CircleAvatar(backgroundImage: AssetImage(_currentSong.image), radius: 40),
                const SizedBox(height: 7),
                Text(_currentSong.title, style: GoogleFonts.montserratAlternates(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),

                // --- Player Control Buttons ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 50,
                      color: Colors.green.shade500,
                      // The icon now depends on our simple `_isPlaying` boolean.
                      icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                      // The action simply toggles between play and pause.
                      onPressed: () {
                        _isPlaying ? AudioService.pause() : AudioService.play();
                      },
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      iconSize: 50,
                      color: Colors.red.shade400,
                      icon: const Icon(Icons.stop_circle),
                      onPressed: AudioService.stop,
                    ),
                  ],
                ),

                // --- Progress Slider ---
                // This part uses a StreamBuilder because it updates very frequently,
                // and it's the most efficient way to handle the slider.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: StreamBuilder<Duration>(
                    stream: AudioService.player.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = AudioService.player.duration ?? Duration.zero;
                      return Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          AudioService.seek(Duration(seconds: value.toInt()));
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // --- Song Selection List ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // We create the song choices dynamically from our `allSongs` list.
                    children: allSongs.map((song) {
                      return _buildSongChoice(song);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // --- Info Box at the Bottom ---
                _buildInfoBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// A helper widget to build one of the tappable song choices.
  Widget _buildSongChoice(Song song) {
    return GestureDetector(
      onTap: () => _selectSong(song),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.15,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(song.image, height: 50, width: 50, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(song.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  /// A helper widget for the text box at the bottom.
  Widget _buildInfoBox() {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
        ),
        padding: const EdgeInsets.all(12),
        child: const Column(
          children: [
            Text("Play Music and Watch Quotes!", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.center),
            SizedBox(height: 4),
            Text("Let music fill your soul and quotes brighten your day! Tap a song to play and enjoy a delightful quote animation.", style: TextStyle(fontSize: 10, color: Colors.black38), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}