import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/her_app_bar.dart';

const List<String> _quotes = [
  "The only way to do great work is to love what you do.",
  "Believe you can and you're halfway there.",
  "Success is not the key to happiness. Happiness is the key to success.",
  "The future belongs to those who believe in the beauty of their dreams.",
  "Do not watch the clock. Do what it does. Keep going.",
];

/// Record and listen to affirmations in your own voice.
class HearYourVoiceScreen extends StatefulWidget {
  const HearYourVoiceScreen({super.key});

  @override
  State<HearYourVoiceScreen> createState() => _HearYourVoiceScreenState();
}

class _HearYourVoiceScreenState extends State<HearYourVoiceScreen> {
  late RecorderController _recorder;
  late PlayerController _player;
  final CarouselSliderController _carousel = CarouselSliderController();

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _playingPath;
  List<String> _recordings = [];
  int _currentQuote = 0;

  @override
  void initState() {
    super.initState();
    _recorder = RecorderController();
    _player = PlayerController();
    _loadRecordings();
  }

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  // ─── Recording ───────────────────────────────────────────
  Future<void> _startRecording() async {
    if (_isRecording) return;
    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder.record(path: path);
      setState(() => _isRecording = true);
    } catch (e) {
      _toast('Error: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    try {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        if (path != null) {
          _recordings.add(path);
          _saveRecordings();
          _currentQuote = (_currentQuote + 1) % _quotes.length;
          _carousel.nextPage();
        }
      });
    } catch (e) {
      _toast('Error: $e');
    }
  }

  // ─── Playback ────────────────────────────────────────────
  Future<void> _play(String path) async {
    if (_isPlaying) return;
    try {
      _player.dispose();
      _player = PlayerController();
      await _player.preparePlayer(path: path, shouldExtractWaveform: true, noOfSamples: 100, volume: 1.0);
      setState(() { _isPlaying = true; _playingPath = path; });
      _player.onCompletion.listen((_) {
        if (mounted) setState(() { _isPlaying = false; _playingPath = null; });
      });
    } catch (e) {
      _toast('Error: $e');
    }
  }

  Future<void> _stopPlayer() async {
    try {
      await _player.stopPlayer();
      setState(() { _isPlaying = false; _playingPath = null; });
    } catch (e) {
      _toast('Error: $e');
    }
  }

  Future<void> _deleteRecording(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
      setState(() {
        _recordings.remove(path);
        _saveRecordings();
        if (_playingPath == path) _stopPlayer();
      });
    } catch (e) {
      _toast('Error: $e');
    }
  }

  Future<void> _saveRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recordings', _recordings);
  }

  Future<void> _loadRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _recordings = prefs.getStringList('recordings') ?? []);
  }

  void _toast(String msg) => Fluttertoast.showToast(msg: msg, gravity: ToastGravity.BOTTOM);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HerAppBar(title: 'Record Quotes'),
      body: Padding(
        padding: AppSpacing.paddingAllMd,
        child: Column(
          children: [
            // ─── Quote Carousel ─────────────────
            CarouselSlider.builder(
              carouselController: _carousel,
              itemCount: _quotes.length,
              options: CarouselOptions(
                height: 170,
                enlargeCenterPage: true,
                onPageChanged: (i, _) => setState(() => _currentQuote = i),
              ),
              itemBuilder: (_, i, __) => Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _quotes[i],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Record your voice to feel the essence of each quote.",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(fontSize: 14, color: AppColors.accent),
            ),
            const SizedBox(height: 16),

            // ─── Waveform / Mic Icon ────────────
            SizedBox(
              height: 80,
              width: double.infinity,
              child: _isRecording
                  ? AudioWaveforms(
                      waveStyle: const WaveStyle(waveColor: AppColors.accent, waveThickness: 4),
                      size: Size(MediaQuery.of(context).size.width - 32, 80),
                      recorderController: _recorder,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Icon(Icons.mic_none_rounded, size: 44, color: AppColors.accent)),
                    ),
            ),
            const SizedBox(height: 16),

            // ─── Controls ───────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRecording ? null : _startRecording,
                  icon: const Icon(Icons.mic),
                  label: const Text('Record'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: !_isRecording ? null : _stopRecording,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ─── Recordings List ────────────────
            Expanded(
              child: ListView.builder(
                itemCount: _recordings.length,
                itemBuilder: (_, i) {
                  final path = _recordings[i];
                  final quote = _quotes[i % _quotes.length];
                  final isActive = _playingPath == path && _isPlaying;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text('Recording ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(quote, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(isActive ? Icons.stop : Icons.play_arrow, color: isActive ? AppColors.error : AppColors.accent),
                            onPressed: () => isActive ? _stopPlayer() : _play(path),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                            onPressed: () => _deleteRecording(path),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
