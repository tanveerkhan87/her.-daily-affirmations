import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

// ─── Data Model ────────────────────────────────────────────
class Song {
  final String path;
  final String title;
  final String image;

  const Song({required this.path, required this.title, required this.image});
}

const List<Song> _allSongs = [
  Song(path: 'assets/sounds/peace.mp3', title: 'Peace', image: 'assets/images/bg9.jpg'),
  Song(path: 'assets/sounds/alone.mp3', title: 'Alone', image: 'assets/images/bg2.jpg'),
  Song(path: 'assets/sounds/nature.mp3', title: 'Nature', image: 'assets/images/bg7.jpg'),
  Song(path: 'assets/sounds/night.mp3', title: 'Night', image: 'assets/images/bg13.jpg'),
  Song(path: 'assets/sounds/colors.mp3', title: 'Colors', image: 'assets/images/bg15.jpg'),
];

// ─── Audio Service (singleton player) ──────────────────────
class AudioService {
  static final AudioPlayer player = AudioPlayer();

  static Future<void> setSong(Song song) async {
    try {
      await player.setAudioSource(
        AudioSource.asset(
          song.path,
          tag: MediaItem(
            id: song.path,
            title: song.title,
            artUri: Uri.parse('asset:///${song.image}'),
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error loading audio source: $e");
    }
  }

  static void play() => player.play();
  static void pause() => player.pause();
  static void stop() => player.stop();
  static void seek(Duration position) => player.seek(position);
}

// ─── Bottom Sheet UI ───────────────────────────────────────
class MusicPlayerSheet extends StatefulWidget {
  const MusicPlayerSheet({super.key});

  @override
  State<MusicPlayerSheet> createState() => _MusicPlayerSheetState();
}

class _MusicPlayerSheetState extends State<MusicPlayerSheet> {
  late Song _currentSong;
  bool _isPlaying = false;
  late StreamSubscription<PlayerState> _playerSub;

  @override
  void initState() {
    super.initState();
    _currentSong = _allSongs.first;
    AudioService.setSong(_currentSong);
    _playerSub = AudioService.player.playerStateStream.listen((state) {
      if (mounted) setState(() => _isPlaying = state.playing);
    });
  }

  @override
  void dispose() {
    _playerSub.cancel();
    super.dispose();
  }

  void _selectSong(Song song) {
    setState(() => _currentSong = song);
    AudioService.setSong(song);
    AudioService.play();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Header ──────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Music",
                style: GoogleFonts.montserratAlternates(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ─── Current Song Info ───────────────
          CircleAvatar(
            backgroundImage: AssetImage(_currentSong.image),
            radius: 36,
          ),
          const SizedBox(height: 8),
          Text(
            _currentSong.title,
            style: GoogleFonts.montserratAlternates(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // ─── Controls ────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 48,
                color: AppColors.success,
                icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                onPressed: () => _isPlaying ? AudioService.pause() : AudioService.play(),
              ),
              const SizedBox(width: 16),
              IconButton(
                iconSize: 48,
                color: AppColors.error,
                icon: const Icon(Icons.stop_circle),
                onPressed: AudioService.stop,
              ),
            ],
          ),

          // ─── Progress Slider ─────────────────
          StreamBuilder<Duration>(
            stream: AudioService.player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = AudioService.player.duration ?? Duration.zero;
              return SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                ),
                child: Slider(
                  activeColor: AppColors.primary,
                  value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
                  max: duration.inSeconds.toDouble().clamp(1, double.infinity),
                  onChanged: (v) => AudioService.seek(Duration(seconds: v.toInt())),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          // ─── Song Selector ───────────────────
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _allSongs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final song = _allSongs[index];
                final isActive = song.title == _currentSong.title;
                return GestureDetector(
                  onTap: () => _selectSong(song),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: isActive
                              ? Border.all(color: AppColors.primary, width: 2)
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(song.image, height: 50, width: 50, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        song.title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? AppColors.primary : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // ─── Info Box ────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  "Play Music and Watch Quotes!",
                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Let music fill your soul and quotes brighten your day!",
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
