import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_fonts.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/providers/style_provider.dart';
import '../../shared/widgets/her_app_bar.dart';

// ─── Theme Preset Model ────────────────────────────────────
class _ThemePreset {
  final String name;
  final Color cardColor;
  final Color fontColor;
  final String fontFamily; // Google Font name
  final String? backgroundImage;
  final LinearGradient? gradient;

  const _ThemePreset({
    required this.name,
    required this.cardColor,
    required this.fontColor,
    required this.fontFamily,
    this.backgroundImage,
    this.gradient,
  });
}

const _ab = Color(0x61FFFFFF);

const List<_ThemePreset> _presets = [
  // ─── Solid Themes ──────────────────────────────────────────
  _ThemePreset(
      name: 'Default',
      cardColor: Color.fromARGB(205, 101, 90, 229),
      fontColor: Colors.white,
      fontFamily: 'Quicksand'),
  _ThemePreset(
      name: 'Ocean',
      cardColor: Color(0xFF1A5276),
      fontColor: Colors.white,
      fontFamily: 'Poppins'),
  _ThemePreset(
      name: 'Rose',
      cardColor: Color(0xFF8E2252),
      fontColor: Color(0xFFFDE8EF),
      fontFamily: 'Lora'),
  _ThemePreset(
      name: 'Forest',
      cardColor: Color(0xFF1E6B3B),
      fontColor: Color(0xFFE8F5E9),
      fontFamily: 'Playfair Display'),
  _ThemePreset(
      name: 'Sunset',
      cardColor: Color(0xFFC45E2A),
      fontColor: Colors.white,
      fontFamily: 'Raleway'),
  _ThemePreset(
      name: 'Midnight',
      cardColor: Color(0xFF1A1A2E),
      fontColor: Color(0xFFE0E0FF),
      fontFamily: 'Montserrat'),
  _ThemePreset(
      name: 'Charcoal',
      cardColor: Color(0xFF2D2D2D),
      fontColor: Color(0xFFF5F5F5),
      fontFamily: 'Nunito'),
  _ThemePreset(
      name: 'Teal',
      cardColor: Color(0xFF006D77),
      fontColor: Color(0xFFEDF6F9),
      fontFamily: 'Dancing Script'),
  _ThemePreset(
      name: 'Plum',
      cardColor: Color(0xFF5B2C6F),
      fontColor: Color(0xFFEBDEF0),
      fontFamily: 'Pacifico'),
  _ThemePreset(
      name: 'Clay',
      cardColor: Color(0xFF8D6E63),
      fontColor: Color(0xFFFFF8E1),
      fontFamily: 'Lobster'),
  _ThemePreset(
      name: 'Navy',
      cardColor: Color(0xFF1B2838),
      fontColor: Color(0xFFB0C4DE),
      fontFamily: 'Caveat'),
  _ThemePreset(
      name: 'Wine',
      cardColor: Color(0xFF722F37),
      fontColor: Color(0xFFF8E8E8),
      fontFamily: 'Satisfy'),
  _ThemePreset(
      name: 'Slate',
      cardColor: Color(0xFF37474F),
      fontColor: Color(0xFFECEFF1),
      fontFamily: 'Great Vibes'),
  _ThemePreset(
      name: 'Mocha',
      cardColor: Color(0xFF4E342E),
      fontColor: Color(0xFFD7CCC8),
      fontFamily: 'Sacramento'),
  _ThemePreset(
      name: 'Indigo',
      cardColor: Color(0xFF283593),
      fontColor: Color(0xFFC5CAE9),
      fontFamily: 'Abril Fatface'),
  _ThemePreset(
      name: 'Olive',
      cardColor: Color(0xFF33691E),
      fontColor: Color(0xFFDCEDC8),
      fontFamily: 'Bebas Neue'),

  // ─── Background Image Themes ───────────────────────────────
  _ThemePreset(
      name: 'Nature 1',
      cardColor: Colors.transparent,
      fontColor: Colors.white,
      fontFamily: 'Oswald',
      backgroundImage: 'assets/images/bg2.jpg'),
  _ThemePreset(
      name: 'Nature 2',
      cardColor: Colors.transparent,
      fontColor: Color(0xFFFFE4B5),
      fontFamily: 'Merriweather',
      backgroundImage: 'assets/images/bg4.jpg'),
  _ThemePreset(
      name: 'Nature 3',
      cardColor: Colors.transparent,
      fontColor: Color(0xFF1F4E3D),
      fontFamily: 'Josefin Sans',
      backgroundImage: 'assets/images/bg5.jpg'),
  _ThemePreset(
      name: 'Minimal',
      cardColor: Colors.transparent,
      fontColor: Color(0xFF2D2D3A),
      fontFamily: 'Comfortaa',
      backgroundImage: 'assets/images/bg6.jpg'),
  _ThemePreset(
      name: 'Calm',
      cardColor: Colors.transparent,
      fontColor: Colors.white,
      fontFamily: 'Righteous',
      backgroundImage: 'assets/images/bg7.jpg'),
  _ThemePreset(
      name: 'Dreamy',
      cardColor: Colors.transparent,
      fontColor: Colors.white,
      fontFamily: 'Shadows Into Light',
      backgroundImage: 'assets/images/bg8.jpg'),
  _ThemePreset(
      name: 'Warm',
      cardColor: Colors.transparent,
      fontColor: Colors.white,
      fontFamily: 'Indie Flower',
      backgroundImage: 'assets/images/bg9.jpg'),
  _ThemePreset(
      name: 'Serenity',
      cardColor: Colors.transparent,
      fontColor: Colors.white,
      fontFamily: 'Amatic SC',
      backgroundImage: 'assets/images/bg10.jpg'),
  _ThemePreset(
      name: 'Cloud',
      cardColor: Colors.transparent,
      fontColor: Color(0xFF2D2D3A),
      fontFamily: 'Permanent Marker',
      backgroundImage: 'assets/images/bg11.jpg'),
  _ThemePreset(
      name: 'Pastel',
      cardColor: Colors.transparent,
      fontColor: Color(0xFF2D2D3A),
      fontFamily: 'Roboto',
      backgroundImage: 'assets/images/bg12.jpg'),

  // ─── Gradient Themes ───────────────────────────────────────
  _ThemePreset(
      name: 'Aurora',
      cardColor: Color(0xFF0F2027),
      fontColor: Colors.white,
      fontFamily: 'Open Sans',
      gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Velvet',
      cardColor: Color(0xFF200122),
      fontColor: Color(0xFFFFE0F0),
      fontFamily: 'Lato',
      gradient: LinearGradient(
          colors: [Color(0xFF200122), Color(0xFF6F0000)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Peach',
      cardColor: Color(0xFFED4264),
      fontColor: Color(0xFF3D0A1A),
      fontFamily: 'Ubuntu',
      gradient: LinearGradient(
          colors: [Color(0xFFED4264), Color(0xFFFFEDBC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Lavender',
      cardColor: Color(0xFFE8CBC0),
      fontColor: Color(0xFF2D2D4A),
      fontFamily: 'PT Sans',
      gradient: LinearGradient(
          colors: [Color(0xFFE8CBC0), Color(0xFF636FA4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Cosmic',
      cardColor: Color(0xFF0B0B2B),
      fontColor: Color(0xFFE0D7FF),
      fontFamily: 'Anton',
      gradient: LinearGradient(colors: [
        Color(0xFF0B0B2B),
        Color(0xFF3A1C71),
        Color(0xFFD76D77),
        Color(0xFFFFAF7B)
      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Mint',
      cardColor: Color(0xFF0BAB64),
      fontColor: Color(0xFFE8FFF4),
      fontFamily: 'Fira Sans',
      gradient: LinearGradient(
          colors: [Color(0xFF0BAB64), Color(0xFF3BB78F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Berry',
      cardColor: Color(0xFF7B2FF7),
      fontColor: Color(0xFFF3E8FF),
      fontFamily: 'Dosis',
      gradient: LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFFC084FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Ember',
      cardColor: Color(0xFFFC4A1A),
      fontColor: Color(0xFFFFF4E8),
      fontFamily: 'Cabin',
      gradient: LinearGradient(
          colors: [Color(0xFFFC4A1A), Color(0xFFF7B733)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Ice',
      cardColor: Color(0xFF2193B0),
      fontColor: Color(0xFFE8F8FF),
      fontFamily: 'Bitter',
      gradient: LinearGradient(
          colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Dusk',
      cardColor: Color(0xFF2C3E50),
      fontColor: Color(0xFFF0E6FF),
      fontFamily: 'Varela Round',
      gradient: LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFFFD746C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Sakura',
      cardColor: Color(0xFFFFC3A0),
      fontColor: Color(0xFF4A1A2E),
      fontFamily: 'Zilla Slab',
      gradient: LinearGradient(
          colors: [Color(0xFFFFC3A0), Color(0xFFFFAFBD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Storm',
      cardColor: Color(0xFF0F0C29),
      fontColor: Colors.white,
      fontFamily: 'Libre Baskerville',
      gradient: LinearGradient(
          colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Coral',
      cardColor: Color(0xFFFF6B6B),
      fontColor: Color(0xFFFFF0F0),
      fontFamily: 'Rubik',
      gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFee5a24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Opal',
      cardColor: Color(0xFF11998E),
      fontColor: Color(0xFFE0FFF8),
      fontFamily: 'Work Sans',
      gradient: LinearGradient(
          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Blush',
      cardColor: Color(0xFFDA4453),
      fontColor: Color(0xFFFFEAEE),
      fontFamily: 'Fjalla One',
      gradient: LinearGradient(
          colors: [Color(0xFFDA4453), Color(0xFF89216B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Galaxy',
      cardColor: Color(0xFF0F0F3D),
      fontColor: Color(0xFFE0D0FF),
      fontFamily: 'Asap',
      gradient: LinearGradient(
          colors: [Color(0xFF0F0F3D), Color(0xFF5C258D), Color(0xFF4389A2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Honey',
      cardColor: Color(0xFFEB8D00),
      fontColor: Color(0xFF3D1800),
      fontFamily: 'Karla',
      gradient: LinearGradient(
          colors: [Color(0xFFEB8D00), Color(0xFFF7CE68)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Aqua',
      cardColor: Color(0xFF005C97),
      fontColor: Color(0xFFE0F0FF),
      fontFamily: 'Barlow',
      gradient: LinearGradient(
          colors: [Color(0xFF005C97), Color(0xFF363795)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Grape',
      cardColor: Color(0xFF360033),
      fontColor: Color(0xFFE8D0FF),
      fontFamily: 'Signika',
      gradient: LinearGradient(
          colors: [Color(0xFF360033), Color(0xFF0B8793)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Flame',
      cardColor: Color(0xFFFF0844),
      fontColor: Color(0xFFFFE8EE),
      fontFamily: 'Kanit',
      gradient: LinearGradient(
          colors: [Color(0xFFFF0844), Color(0xFFFFB199)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),

  // ─── 30 New Gradient Themes ────────────────────────────────
  _ThemePreset(
      name: 'Twilight',
      cardColor: Color(0xFF0F2027),
      fontColor: Colors.white,
      fontFamily: 'Teko',
      gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF2C5364), Color(0xFF734B6D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Cotton Candy',
      cardColor: Color(0xFFFF9A9E),
      fontColor: Color(0xFF4A1A2E),
      fontFamily: 'Cinzel',
      gradient: LinearGradient(
          colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Northern Lights',
      cardColor: Color(0xFF43C6AC),
      fontColor: Color(0xFFE8FFF8),
      fontFamily: 'Kalam',
      gradient: LinearGradient(
          colors: [Color(0xFF43C6AC), Color(0xFF191654)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Deep Sea',
      cardColor: Color(0xFF141E30),
      fontColor: Color(0xFFB0E0E6),
      fontFamily: 'Cookie',
      gradient: LinearGradient(
          colors: [Color(0xFF141E30), Color(0xFF243B55)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Mango',
      cardColor: Color(0xFFFFE259),
      fontColor: Color(0xFF4A2800),
      fontFamily: 'Lobster Two',
      gradient: LinearGradient(
          colors: [Color(0xFFFFE259), Color(0xFFFFA751)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Royal',
      cardColor: Color(0xFF141852),
      fontColor: Color(0xFFFFD700),
      fontFamily: 'Kaushan Script',
      gradient: LinearGradient(
          colors: [Color(0xFF141852), Color(0xFF2C2F7B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Blossom',
      cardColor: Color(0xFFE8B4B8),
      fontColor: Color(0xFF3D1A3E),
      fontFamily: 'Courgette',
      gradient: LinearGradient(
          colors: [Color(0xFFE8B4B8), Color(0xFF8B5CF6), Color(0xFFA78BFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Nebula',
      cardColor: Color(0xFF1A002E),
      fontColor: Color(0xFFE0D7FF),
      fontFamily: 'Grand Hotel',
      gradient: LinearGradient(
          colors: [Color(0xFF1A002E), Color(0xFF5B247A), Color(0xFF1BCEDF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Emerald',
      cardColor: Color(0xFF134E5E),
      fontColor: Colors.white,
      fontFamily: 'Yellowtail',
      gradient: LinearGradient(
          colors: [Color(0xFF134E5E), Color(0xFF71B280)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Rose Gold',
      cardColor: Color(0xFFB76E79),
      fontColor: Colors.white,
      fontFamily: 'Tangerine',
      gradient: LinearGradient(
          colors: [Color(0xFFB76E79), Color(0xFFE8CBC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Moonlight',
      cardColor: Color(0xFF0D1B2A),
      fontColor: Color(0xFFE0E1DD),
      fontFamily: 'Parisienne',
      gradient: LinearGradient(
          colors: [Color(0xFF0D1B2A), Color(0xFF1B263B), Color(0xFF415A77)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Watermelon',
      cardColor: Color(0xFFFD4659),
      fontColor: Color(0xFFFFF0F2),
      fontFamily: 'Allura',
      gradient: LinearGradient(
          colors: [Color(0xFFFD4659), Color(0xFF28DF99)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Cinnamon',
      cardColor: Color(0xFF4A1A2C),
      fontColor: Color(0xFFF8E8E8),
      fontFamily: 'Handlee',
      gradient: LinearGradient(
          colors: [Color(0xFF4A1A2C), Color(0xFFCE7E5C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Electric',
      cardColor: Color(0xFF0652DD),
      fontColor: Color(0xFFE8F0FF),
      fontFamily: 'Nothing You Could Do',
      gradient: LinearGradient(
          colors: [Color(0xFF0652DD), Color(0xFF1289A7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Sandstorm',
      cardColor: Color(0xFFC2B280),
      fontColor: Color(0xFF2E1A00),
      fontFamily: 'Homemade Apple',
      gradient: LinearGradient(
          colors: [Color(0xFFC2B280), Color(0xFFE8D5B7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Crimson',
      cardColor: Color(0xFF8E0E00),
      fontColor: Colors.white,
      fontFamily: 'Covered By Your Grace',
      gradient: LinearGradient(
          colors: [Color(0xFF8E0E00), Color(0xFF1F1C18)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Tropical',
      cardColor: Color(0xFF38B2AC),
      fontColor: Color(0xFFE0FFFA),
      fontFamily: 'Gloria Hallelujah',
      gradient: LinearGradient(
          colors: [Color(0xFF38B2AC), Color(0xFF0BC5EA), Color(0xFF4299E1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Amethyst',
      cardColor: Color(0xFF6B21A8),
      fontColor: Color(0xFFF3E8FF),
      fontFamily: 'Rock Salt',
      gradient: LinearGradient(
          colors: [Color(0xFF6B21A8), Color(0xFF9333EA), Color(0xFFA855F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Sunrise',
      cardColor: Color(0xFFFF512F),
      fontColor: Color(0xFFFFF0E8),
      fontFamily: 'Patrick Hand',
      gradient: LinearGradient(
          colors: [Color(0xFFFF512F), Color(0xFFF09819)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Frost',
      cardColor: Color(0xFF000428),
      fontColor: Color(0xFFE0F7FA),
      fontFamily: 'Neucha',
      gradient: LinearGradient(
          colors: [Color(0xFF000428), Color(0xFF004E92)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Candy',
      cardColor: Color(0xFFD53369),
      fontColor: Color(0xFFFFEAF2),
      fontFamily: 'Architects Daughter',
      gradient: LinearGradient(
          colors: [Color(0xFFD53369), Color(0xFFDAED77)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Neon',
      cardColor: Color(0xFF00F5A0),
      fontColor: Color(0xFF0A1A2E),
      fontFamily: 'Bangers',
      gradient: LinearGradient(
          colors: [Color(0xFF00F5A0), Color(0xFF00D9F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Plum Wine',
      cardColor: Color(0xFF3C1053),
      fontColor: Color(0xFFE8D0FF),
      fontFamily: 'Russo One',
      gradient: LinearGradient(
          colors: [Color(0xFF3C1053), Color(0xFFAD5389)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Peacock',
      cardColor: Color(0xFF004D7A),
      fontColor: Color(0xFFE0F4F8),
      fontFamily: 'Alfa Slab One',
      gradient: LinearGradient(
          colors: [Color(0xFF004D7A), Color(0xFF008793), Color(0xFF00BF72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Pomegranate',
      cardColor: Color(0xFF9B2335),
      fontColor: Color(0xFFFFF0F0),
      fontFamily: 'Bungee',
      gradient: LinearGradient(
          colors: [Color(0xFF9B2335), Color(0xFFE94560)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Lagoon',
      cardColor: Color(0xFF005AA7),
      fontColor: Color(0xFFEAF4FF),
      fontFamily: 'Francois One',
      gradient: LinearGradient(
          colors: [Color(0xFF005AA7), Color(0xFFFFFDE4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Cherry',
      cardColor: Color(0xFFEB3349),
      fontColor: Color(0xFFFFE8EC),
      fontFamily: 'Patua One',
      gradient: LinearGradient(
          colors: [Color(0xFFEB3349), Color(0xFFF45C43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Misty',
      cardColor: Color(0xFF606C88),
      fontColor: Color(0xFFE8ECF5),
      fontFamily: 'Monda',
      gradient: LinearGradient(
          colors: [Color(0xFF606C88), Color(0xFF3F4C6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Sapphire',
      cardColor: Color(0xFF0C3483),
      fontColor: Colors.white,
      fontFamily: 'Carter One',
      gradient: LinearGradient(
          colors: [Color(0xFF0C3483), Color(0xFFA2B6DF), Color(0xFF6B8DD6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Lush',
      cardColor: Color(0xFF56AB2F),
      fontColor: Color(0xFF0A1A0A),
      fontFamily: 'Fredoka One',
      gradient: LinearGradient(
          colors: [Color(0xFF56AB2F), Color(0xFFA8E063)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),

  // ─── 50 More Gradient Themes ───────────────────────────────
  _ThemePreset(
      name: 'Orchid',
      cardColor: Color(0xFF834D9B),
      fontColor: Color(0xFFF5E8FF),
      fontFamily: 'Chewy',
      gradient: LinearGradient(
          colors: [Color(0xFF834D9B), Color(0xFFD04ED6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Dune',
      cardColor: Color(0xFFA67C52),
      fontColor: Colors.white,
      fontFamily: 'Special Elite',
      gradient: LinearGradient(
          colors: [Color(0xFFA67C52), Color(0xFFD4A76A), Color(0xFFF0D9B5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Twilight Sky',
      cardColor: Color(0xFF2B1055),
      fontColor: Color(0xFFE0D7FF),
      fontFamily: 'Alegreya',
      gradient: LinearGradient(
          colors: [Color(0xFF2B1055), Color(0xFFD76D77), Color(0xFFFFAF7B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Bubblegum',
      cardColor: Color(0xFFFC5C7D),
      fontColor: Color(0xFFFFEAF0),
      fontFamily: 'Crimson Text',
      gradient: LinearGradient(
          colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Evergreen',
      cardColor: Color(0xFF11998E),
      fontColor: Color(0xFFE0FFF6),
      fontFamily: 'EB Garamond',
      gradient: LinearGradient(
          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Moonrise',
      cardColor: Color(0xFF0F0C29),
      fontColor: Color(0xFFFFE0B2),
      fontFamily: 'Cormorant Garamond',
      gradient: LinearGradient(
          colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Blueberry',
      cardColor: Color(0xFF4568DC),
      fontColor: Color(0xFFEAF0FF),
      fontFamily: 'Philosopher',
      gradient: LinearGradient(
          colors: [Color(0xFF4568DC), Color(0xFFB06AB3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Tangerine',
      cardColor: Color(0xFFFF6A00),
      fontColor: Color(0xFFFFF0E0),
      fontFamily: 'Domine',
      gradient: LinearGradient(
          colors: [Color(0xFFFF6A00), Color(0xFFEE0979)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Glacier',
      cardColor: Color(0xFF74EBD5),
      fontColor: Color(0xFF0A2E3D),
      fontFamily: 'Vollkorn',
      gradient: LinearGradient(
          colors: [Color(0xFF74EBD5), Color(0xFFACB6E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Magenta',
      cardColor: Color(0xFFA8196B),
      fontColor: Color(0xFFFFE8F4),
      fontFamily: 'Arapey',
      gradient: LinearGradient(
          colors: [Color(0xFFA8196B), Color(0xFFFC5C7D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Deep Purple',
      cardColor: Color(0xFF3D0066),
      fontColor: Color(0xFFE0D7FF),
      fontFamily: 'Unna',
      gradient: LinearGradient(
          colors: [Color(0xFF3D0066), Color(0xFF6A0DAD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Firefly',
      cardColor: Color(0xFF0D324D),
      fontColor: Color(0xFFE0F7FA),
      fontFamily: 'Gilda Display',
      gradient: LinearGradient(
          colors: [Color(0xFF0D324D), Color(0xFF7F5A83), Color(0xFFA188A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Raspberry',
      cardColor: Color(0xFF870058),
      fontColor: Color(0xFFFFE0F0),
      fontFamily: 'Marcellus',
      gradient: LinearGradient(
          colors: [Color(0xFF870058), Color(0xFFCA2B6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Sunflower',
      cardColor: Color(0xFFF7971E),
      fontColor: Color(0xFF3D1800),
      fontFamily: 'Tenor Sans',
      gradient: LinearGradient(
          colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Ocean Blue',
      cardColor: Color(0xFF2E3192),
      fontColor: Color(0xFFE8EAFF),
      fontFamily: 'Prata',
      gradient: LinearGradient(
          colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Peony',
      cardColor: Color(0xFFED6EA0),
      fontColor: Color(0xFFFFEAF2),
      fontFamily: 'Rozha One',
      gradient: LinearGradient(
          colors: [Color(0xFFED6EA0), Color(0xFFEC8C69)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Jade',
      cardColor: Color(0xFF136A57),
      fontColor: Color(0xFFE0F2E9),
      fontFamily: 'Federo',
      gradient: LinearGradient(
          colors: [Color(0xFF136A57), Color(0xFF2ECC71)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Titanium',
      cardColor: Color(0xFF283048),
      fontColor: Color(0xFFECEFF1),
      fontFamily: 'Julius Sans One',
      gradient: LinearGradient(
          colors: [Color(0xFF283048), Color(0xFF859398)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Paradise',
      cardColor: Color(0xFF1D976C),
      fontColor: Color(0xFFE0FFE8),
      fontFamily: 'Unica One',
      gradient: LinearGradient(
          colors: [Color(0xFF1D976C), Color(0xFF93F9B9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Dawn',
      cardColor: Color(0xFFF3904F),
      fontColor: Color(0xFFFFF4E8),
      fontFamily: 'Economica',
      gradient: LinearGradient(
          colors: [Color(0xFFF3904F), Color(0xFF3B4371)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Velvet Night',
      cardColor: Color(0xFF16222A),
      fontColor: Color(0xFFE0D7FF),
      fontFamily: 'Marvel',
      gradient: LinearGradient(
          colors: [Color(0xFF16222A), Color(0xFF3A6073)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Borealis',
      cardColor: Color(0xFF00B4DB),
      fontColor: Color(0xFFE0F8FF),
      fontFamily: 'Syncopate',
      gradient: LinearGradient(
          colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Rosewood',
      cardColor: Color(0xFF7F0000),
      fontColor: Color(0xFFFFE0E0),
      fontFamily: 'Gruppo',
      gradient: LinearGradient(
          colors: [Color(0xFF7F0000), Color(0xFFBA2D2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Petal',
      cardColor: Color(0xFFEECDA3),
      fontColor: Color(0xFF4A1A2E),
      fontFamily: 'Yanone Kaffeesatz',
      gradient: LinearGradient(
          colors: [Color(0xFFEECDA3), Color(0xFFEF629F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Cosmos',
      cardColor: Color(0xFF200122),
      fontColor: Color(0xFFE0D7FF),
      fontFamily: 'Abel',
      gradient: LinearGradient(
          colors: [Color(0xFF200122), Color(0xFF6F0000), Color(0xFF200122)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Seashore',
      cardColor: Color(0xFF209CFF),
      fontColor: Color(0xFF0A1A3D),
      fontFamily: 'Pathway Gothic One',
      gradient: LinearGradient(
          colors: [Color(0xFF209CFF), Color(0xFF68E0CF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Maple',
      cardColor: Color(0xFFB44D12),
      fontColor: Colors.white,
      fontFamily: 'Six Caps',
      gradient: LinearGradient(
          colors: [Color(0xFFB44D12), Color(0xFFD4A76A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Arctic',
      cardColor: Color(0xFF076585),
      fontColor: Color(0xFF0A1A2E),
      fontFamily: 'News Cycle',
      gradient: LinearGradient(
          colors: [Color(0xFF076585), Color(0xFFCDE8F0), Color(0xFF076585)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Violet Dream',
      cardColor: Color(0xFF7B4397),
      fontColor: Color(0xFFF5E8FF),
      fontFamily: 'Oleo Script',
      gradient: LinearGradient(
          colors: [Color(0xFF7B4397), Color(0xFFDC2430)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Copper',
      cardColor: Color(0xFFB79891),
      fontColor: Color(0xFF1A0A1A),
      fontFamily: 'Rancho',
      gradient: LinearGradient(
          colors: [Color(0xFFB79891), Color(0xFF94716B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Frosty Mint',
      cardColor: Color(0xFF00CDAC),
      fontColor: Color(0xFFE0FFF8),
      fontFamily: 'Spinnaker',
      gradient: LinearGradient(
          colors: [Color(0xFF00CDAC), Color(0xFF02AAB0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Hibiscus',
      cardColor: Color(0xFFE44D26),
      fontColor: Color(0xFFFFEEE8),
      fontFamily: 'Allerta',
      gradient: LinearGradient(
          colors: [Color(0xFFE44D26), Color(0xFFF16529)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Moonbeam',
      cardColor: Color(0xFF2C3E50),
      fontColor: Color(0xFFE0E1DD),
      fontFamily: 'Alice',
      gradient: LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Lilac',
      cardColor: Color(0xFFA770EF),
      fontColor: Color(0xFFF5E8FF),
      fontFamily: 'Brawler',
      gradient: LinearGradient(
          colors: [Color(0xFFA770EF), Color(0xFFCF8BF3), Color(0xFFFDB99B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Wildberry',
      cardColor: Color(0xFF5D26C1),
      fontColor: Color(0xFFEFE0FF),
      fontFamily: 'Cantata One',
      gradient: LinearGradient(
          colors: [Color(0xFF5D26C1), Color(0xFFB721FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Caramel',
      cardColor: Color(0xFFC97B25),
      fontColor: Color(0xFF2E1400),
      fontFamily: 'Copse',
      gradient: LinearGradient(
          colors: [Color(0xFFC97B25), Color(0xFFE8D5B7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Seafoam',
      cardColor: Color(0xFF0ABFBC),
      fontColor: Color(0xFFE0FFFE),
      fontFamily: 'Enriqueta',
      gradient: LinearGradient(
          colors: [Color(0xFF0ABFBC), Color(0xFFFC354C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Starlit',
      cardColor: Color(0xFF0C0C1D),
      fontColor: Color(0xFFE0D7FF),
      fontFamily: 'Habibi',
      gradient: LinearGradient(
          colors: [Color(0xFF0C0C1D), Color(0xFF3B3B6D), Color(0xFF6666A0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Pistachio',
      cardColor: Color(0xFF93C572),
      fontColor: Color(0xFF0A2E1A),
      fontFamily: 'Judson',
      gradient: LinearGradient(
          colors: [Color(0xFF93C572), Color(0xFFC5E17A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Eclipse',
      cardColor: Color(0xFF1E1E2E),
      fontColor: Color(0xFFF5C842),
      fontFamily: 'Kameron',
      gradient: LinearGradient(
          colors: [Color(0xFF1E1E2E), Color(0xFF373B44)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Rosewater',
      cardColor: Color(0xFFF8B4B4),
      fontColor: Color(0xFF4A1A2E),
      fontFamily: 'Mate',
      gradient: LinearGradient(
          colors: [Color(0xFFF8B4B4), Color(0xFFEEA4CE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Indigo Night',
      cardColor: Color(0xFF1A237E),
      fontColor: Color(0xFFC5CAE9),
      fontFamily: 'Neuton',
      gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3949AB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Sherbet',
      cardColor: Color(0xFFF79D00),
      fontColor: Color(0xFFFFF6E0),
      fontFamily: 'Ovo',
      gradient: LinearGradient(
          colors: [Color(0xFFF79D00), Color(0xFF64F38C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Volcano',
      cardColor: Color(0xFF600000),
      fontColor: Color(0xFFFFCCBC),
      fontFamily: 'Petrona',
      gradient: LinearGradient(
          colors: [Color(0xFF600000), Color(0xFFAB0000), Color(0xFFFF6E00)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
  _ThemePreset(
      name: 'Mauve',
      cardColor: Color(0xFF8E7CC3),
      fontColor: Color(0xFFF0EAFF),
      fontFamily: 'Quattrocento',
      gradient: LinearGradient(
          colors: [Color(0xFF8E7CC3), Color(0xFFC27BA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Skyline',
      cardColor: Color(0xFF1488CC),
      fontColor: Color(0xFFE0F0FF),
      fontFamily: 'Radley',
      gradient: LinearGradient(
          colors: [Color(0xFF1488CC), Color(0xFF2B32B2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Chai',
      cardColor: Color(0xFF6B4226),
      fontColor: Color(0xFFFFF8E1),
      fontFamily: 'Rosario',
      gradient: LinearGradient(
          colors: [Color(0xFF6B4226), Color(0xFFB8860B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Silver Lake',
      cardColor: Color(0xFF606C88),
      fontColor: Colors.white,
      fontFamily: 'Tienne',
      gradient: LinearGradient(
          colors: [Color(0xFF606C88), Color(0xFFB0BEC5), Color(0xFF606C88)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Passion Fruit',
      cardColor: Color(0xFFE91E63),
      fontColor: Color(0xFFFFE8F0),
      fontFamily: 'Vidaloka',
      gradient: LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
  _ThemePreset(
      name: 'Cool Breeze',
      cardColor: Color(0xFF00C9FF),
      fontColor: Color(0xFF0A1A2E),
      fontFamily: 'Playfair Display SC',
      gradient: LinearGradient(
          colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
];

/// Screen to select a visual theme preset for quote cards.
class StylesScreen extends StatelessWidget {
  const StylesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HerAppBar(title: 'Card Themes'),
      body: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: _presets.length,
          itemBuilder: (context, index) {
            final preset = _presets[index];
            return _PresetTile(preset: preset, isDark: isDark);
          },
        ),
      ),
    );
  }
}

class _PresetTile extends StatefulWidget {
  final _ThemePreset preset;
  final bool isDark;

  const _PresetTile({required this.preset, required this.isDark});

  @override
  State<_PresetTile> createState() => _PresetTileState();
}

class _PresetTileState extends State<_PresetTile> {
  bool _pressed = false;

  bool _isSelected(StyleProvider style) {
    return style.fontFamily == widget.preset.fontFamily &&
        style.cardColor.value == widget.preset.cardColor.value &&
        style.backgroundImage == (widget.preset.backgroundImage ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final preset = widget.preset;
    final style = context.watch<StyleProvider>();
    final selected = _isSelected(style);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        context.read<StyleProvider>().applyTheme(
              fontFamily: preset.fontFamily,
              cardColor: preset.cardColor,
              fontColor: preset.fontColor,
              actionBarColor: _ab,
              backgroundImage: preset.backgroundImage,
              gradient: preset.gradient,
            );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.95 : (selected ? 1.03 : 1.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: (preset.gradient == null && preset.backgroundImage == null)
                ? preset.cardColor
                : null,
            gradient: preset.gradient,
            image: preset.backgroundImage != null
                ? DecorationImage(
                    image: AssetImage(preset.backgroundImage!),
                    fit: BoxFit.cover,
                  )
                : null,
            borderRadius: BorderRadius.circular(20),
            border: selected
                ? Border.all(color: Colors.white, width: 3)
                : Border.all(color: Colors.transparent, width: 3),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(widget.isDark ? 0.3 : 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17), // accounts for 3px border
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ─── Subtle Bottom Gradient for Text Readability ───
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.5),
                        ],
                        stops: const [0.4, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                // ─── Quote Preview ──────────────────
                Builder(builder: (context) {
                  final isLightText =
                      ThemeData.estimateBrightnessForColor(preset.fontColor) ==
                          Brightness.light;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '"Believe\nin yourself"',
                        textAlign: TextAlign.center,
                        style: AppFonts.safeGetFont(
                          preset.fontFamily,
                          color: preset.fontColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          shadows: [
                            if (isLightText)
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                              )
                            else
                              Shadow(
                                blurRadius: 10,
                                color: Colors.white.withOpacity(0.4),
                                offset: const Offset(0, 1),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // ─── Name Badge & Checkmark ─────────────────────
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          preset.name,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                            shadows: [
                              Shadow(
                                blurRadius: 6,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (selected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.black,
                            weight: 900,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
