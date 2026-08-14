import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routes/page_transitions.dart';
import '../../shared/widgets/her_app_bar.dart';
import 'own_affirmations_screen.dart';

// ─── Data Model ────────────────────────────────────────────
class AffirmationData {
  final String affirmation;
  final String fontFamily;
  final Color textColor;
  final Color backgroundColor;

  const AffirmationData({
    required this.affirmation,
    required this.fontFamily,
    required this.textColor,
    required this.backgroundColor,
  });

  Map<String, dynamic> toJson() => {
        'affirmation': affirmation,
        'fontFamily': fontFamily,
        'textColor': textColor.value,
        'backgroundColor': backgroundColor.value,
      };

  factory AffirmationData.fromJson(Map<String, dynamic> j) => AffirmationData(
        affirmation: j['affirmation'],
        fontFamily: j['fontFamily'],
        textColor: Color(j['textColor']),
        backgroundColor: Color(j['backgroundColor']),
      );
}

// ─── Constants ─────────────────────────────────────────────
final List<String> _fontFamilies = AppFonts.available;
final List<Color> _modernColors = [
  Colors.white,
  Colors.black,
  const Color(0xFF1E1E2E), // Dark slate
  const Color(0xFFF3F4F6), // Soft white
  const Color(0xFFE9D5FF), // Soft purple
  const Color(0xFFFBCFE8), // Soft pink
  const Color(0xFFBFDBFE), // Soft blue
  const Color(0xFFA7F3D0), // Soft green
  const Color(0xFFFDE68A), // Soft yellow
  const Color(0xFF7C3AED), // Vibrant purple
  const Color(0xFFDB2777), // Vibrant pink
  const Color(0xFF2563EB), // Vibrant blue
  const Color(0xFF059669), // Vibrant green
  const Color(0xFFD97706), // Vibrant orange
  const Color(0xFF9CA3AF), // Grey
  const Color(0xFFF472B6), // Pink 400
  const Color(0xFFFB7185), // Rose 400
  const Color(0xFFEF4444), // Red 500
  const Color(0xFFF97316), // Orange 500
  const Color(0xFFEAB308), // Yellow 500
  const Color(0xFF84CC16), // Lime 500
  const Color(0xFF22C55E), // Green 500
  const Color(0xFF10B981), // Emerald 500
  const Color(0xFF14B8A6), // Teal 500
  const Color(0xFF06B6D4), // Cyan 500
  const Color(0xFF0EA5E9), // Sky 500
  const Color(0xFF3B82F6), // Blue 500
  const Color(0xFF6366F1), // Indigo 500
  const Color(0xFF8B5CF6), // Violet 500
  const Color(0xFFA855F7), // Purple 500
  const Color(0xFFD946EF), // Fuchsia 500
  const Color(0xFF475569), // Slate 600
];

/// Screen where users create custom affirmations.
class CreateAffirmationScreen extends StatefulWidget {
  const CreateAffirmationScreen({super.key});

  @override
  State<CreateAffirmationScreen> createState() => _CreateAffirmationScreenState();
}

class _CreateAffirmationScreenState extends State<CreateAffirmationScreen> {
  final TextEditingController _controller = TextEditingController();
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.grey;
  String _selectedFont = AppFonts.defaultFont;
  List<AffirmationData> _affirmations = [];

  @override
  void initState() {
    super.initState();
    _loadAffirmations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadAffirmations() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('affirmations') ?? [];
    setState(() {
      _affirmations = list.map((s) => AffirmationData.fromJson(jsonDecode(s))).toList();
    });
  }

  Future<void> _saveAffirmations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'affirmations',
      _affirmations.map((a) => jsonEncode(a.toJson())).toList(),
    );
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _showEmptyDialog();
      return;
    }
    _affirmations.add(AffirmationData(
      affirmation: text,
      fontFamily: _selectedFont,
      textColor: _textColor,
      backgroundColor: _backgroundColor,
    ));
    _controller.clear();
    _saveAffirmations();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Affirmation Saved')),
    );
  }

  void _showEmptyDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Empty Affirmation'),
        content: const Text('Please write an affirmation before saving.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HerAppBar(
        title: 'Create Affirmation',
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.check_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Preview Card ───────────────────
            Container(
              height: 320,
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Center(
                child: TextFormField(
                  controller: _controller,
                  maxLines: null,
                  textAlign: TextAlign.center,
                  style: AppFonts.safeGetFont(_selectedFont, color: _textColor, fontSize: 28),
                  maxLength: 150,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: false,
                    hintText: 'Write your affirmation...',
                    hintStyle: TextStyle(color: _textColor.withOpacity(0.4), fontSize: 22),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    counterStyle: TextStyle(color: _textColor.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ─── Font Selector ──────────────────
            Text('Font Style', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _fontFamilies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final font = _fontFamilies[i];
                  final isActive = font == _selectedFont;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFont = font),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary.withOpacity(0.1) : (isDark ? AppColors.cardDark : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(10),
                        border: isActive ? Border.all(color: AppColors.primary, width: 1.5) : null,
                      ),
                      alignment: Alignment.center,
                      child: Text('Aa', style: AppFonts.safeGetFont(font, fontSize: 18)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // ─── Text Color ─────────────────────
            Text('Text Color', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _ColorRow(
              selected: _textColor,
              onSelect: (c) => setState(() => _textColor = c),
            ),
            const SizedBox(height: 20),

            // ─── Background Color ───────────────
            Text('Background', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _ColorRow(
              selected: _backgroundColor,
              onSelect: (c) => setState(() => _backgroundColor = c),
            ),
            const SizedBox(height: 28),

            // ─── View Saved ─────────────────────
            OutlinedButton.icon(
              onPressed: () {
                if (_affirmations.isNotEmpty) {
                  Navigator.push(context, SlidePageRoute(
                    page: OwnAffirmationsScreen(affirmations: _affirmations),
                  ));
                } else {
                  _showEmptyDialog();
                }
              },
              icon: const Icon(Icons.collections_bookmark_rounded),
              label: const Text('View Saved Affirmations'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Horizontal color picker row.
class _ColorRow extends StatelessWidget {
  final Color selected;
  final ValueChanged<Color> onSelect;

  const _ColorRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _modernColors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final color = _modernColors[i];
          final isActive = color.value == selected.value;
          final isLightColor = ThemeData.estimateBrightnessForColor(color) == Brightness.light;
          final innerBorderColor = isLightColor ? Colors.black12 : Colors.transparent;

          return GestureDetector(
            onTap: () => onSelect(color),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? (color == Colors.white ? Colors.black38 : color) : Colors.transparent, 
                  width: 2.5
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  width: isActive ? 30 : 38,
                  height: isActive ? 30 : 38,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: innerBorderColor, width: 1),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
