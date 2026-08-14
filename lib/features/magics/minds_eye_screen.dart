import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/her_app_bar.dart';

const List<String> _quotes = [
  "The future belongs to those who believe in the beauty of their dreams.",
  "The only way out of the labyrinth of suffering is to forgive.",
  "An eye for an eye only ends up making the whole world blind.",
  "Love is composed of a single soul inhabiting two bodies.",
  "Keep your face to the sunshine and you cannot see a shadow.",
  "The soul is dyed the color of its thoughts.",
  "The power of imagination makes us infinite.",
  "The journey of a thousand miles begins with one step.",
  "The mind is everything. What you think you become.",
  "Dream big and dare to fail.",
];

/// Mind's Eye: front camera + motivational quotes.
class MindsEyeScreen extends StatefulWidget {
  const MindsEyeScreen({super.key});

  @override
  State<MindsEyeScreen> createState() => _MindsEyeScreenState();
}

class _MindsEyeScreenState extends State<MindsEyeScreen> {
  CameraController? _camera;
  bool _initialized = false;
  int _quoteIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
      _camera = CameraController(front, ResolutionPreset.medium, imageFormatGroup: ImageFormatGroup.jpeg);
      await _camera!.initialize();
      if (mounted) setState(() => _initialized = true);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HerAppBar(title: "Mind's Eye"),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ─── Camera Preview ─────────────
                Padding(
                  padding: AppSpacing.paddingAllMd,
                  child: ZoomIn(
                    child: Container(
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 3),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg - 3),
                        child: CameraPreview(_camera!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'See yourself. Believe the words.',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),

                // ─── Quote Section ──────────────
                Expanded(
                  child: FadeInUp(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary.withOpacity(0.85), AppColors.primaryDark],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSpacing.radiusXl),
                          topRight: Radius.circular(AppSpacing.radiusXl),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Padding(
                                  key: ValueKey(_quoteIndex),
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    _quotes[_quoteIndex],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () => setState(() =>
                                      _quoteIndex = (_quoteIndex - 1 + _quotes.length) % _quotes.length),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: const Text('Back'),
                                ),
                                ElevatedButton(
                                  onPressed: () => setState(() =>
                                      _quoteIndex = (_quoteIndex + 1) % _quotes.length),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: const Text('Next'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
