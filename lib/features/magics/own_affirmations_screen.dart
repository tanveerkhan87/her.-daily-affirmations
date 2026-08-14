import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/her_app_bar.dart';
import 'create_affirmation_screen.dart';

/// Carousel view of user-created affirmations.
class OwnAffirmationsScreen extends StatefulWidget {
  final List<AffirmationData> affirmations;

  const OwnAffirmationsScreen({super.key, required this.affirmations});

  @override
  State<OwnAffirmationsScreen> createState() => _OwnAffirmationsScreenState();
}

class _OwnAffirmationsScreenState extends State<OwnAffirmationsScreen> {
  late List<AffirmationData> _affirmations;

  @override
  void initState() {
    super.initState();
    _affirmations = List.from(widget.affirmations);
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('affirmations');
    if (list != null) {
      if (mounted) {
        setState(() {
          _affirmations = list.map((s) => AffirmationData.fromJson(jsonDecode(s))).toList();
        });
      }
    }
  }

  Future<void> _delete(int index) async {
    setState(() => _affirmations.removeAt(index));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'affirmations',
      _affirmations.map((a) => jsonEncode(a.toJson())).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HerAppBar(title: 'My Affirmations'),
      body: _affirmations.isEmpty
          ? const Center(child: Text('No affirmations yet', style: TextStyle(color: Colors.grey)))
          : CarouselSlider.builder(
              itemCount: _affirmations.length,
              itemBuilder: (context, index, _) {
                final aff = _affirmations[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: aff.backgroundColor,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Builder(
                      builder: (context) {
                        final isLightBg = ThemeData.estimateBrightnessForColor(aff.backgroundColor) == Brightness.light;
                        final overlayColor = isLightBg ? Colors.black.withOpacity(0.06) : Colors.black.withOpacity(0.25);
                        final iconColor = isLightBg ? Colors.black87 : Colors.white;

                        return Stack(
                          children: [
                            // ─── Affirmation Text ─────────
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                                child: Text(
                                  aff.affirmation,
                                  textAlign: TextAlign.center,
                                  style: AppFonts.safeGetFont(
                                    aff.fontFamily,
                                    fontSize: 28,
                                    color: aff.textColor,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                            // ─── Delete Button ────────────
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: overlayColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () => _delete(index),
                                  icon: Icon(Icons.delete_outline_rounded, color: iconColor, size: 24),
                                  tooltip: 'Delete Affirmation',
                                ),
                              ),
                            ),
                            // ─── Badge ────────────
                            Positioned(
                              bottom: 24,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: overlayColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "My Affirmation",
                                    style: AppFonts.safeGetFont(
                                      aff.fontFamily,
                                      color: iconColor, 
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.75,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
            ),
    );
  }
}
