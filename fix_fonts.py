import re
import random

fonts = [
    "Quicksand", "Poppins", "Lora", "Playfair Display", "Raleway", 
    "Montserrat", "Nunito", "Dancing Script", "Pacifico", "Lobster", 
    "Caveat", "Satisfy", "Great Vibes", "Sacramento", "Abril Fatface", 
    "Bebas Neue", "Oswald", "Merriweather", "Josefin Sans", "Comfortaa", 
    "Righteous", "Shadows Into Light", "Indie Flower", "Amatic SC", "Permanent Marker",
    "Roboto", "Open Sans", "Lato", "Ubuntu", "PT Sans", 
    "Anton", "Fira Sans", "Dosis", "Cabin", "Bitter", 
    "Varela Round", "Zilla Slab", "Libre Baskerville", "Noto Serif", "Rubik",
    "Work Sans", "Fjalla One", "Asap", "Karla", "Barlow",
    "Signika", "Kanit", "Teko", "Cinzel", "Kalam", 
    "Cookie", "Lobster Two", "Kaushan Script", "Courgette", "Grand Hotel", 
    "Yellowtail", "Tangerine", "Parisienne", "Allura", "Handlee", 
    "Nothing You Could Do", "Homemade Apple", "Covered By Your Grace", "Gloria Hallelujah", "Rock Salt", 
    "Patrick Hand", "Neucha", "Architects Daughter", "Bangers", "Russo One", 
    "Orbitron", "Alfa Slab One", "Bungee", "Monoton", "Francois One",
    "Patua One", "Monda", "Carter One", "Fredoka One", "Sigmar One",
    "Chewy", "Special Elite", "Alegreya", "Crimson Text", "EB Garamond",
    "Cormorant Garamond", "Playfair Display SC", "Philosopher", "Trocchi", "Domine",
    "Gelasio", "Vollkorn", "Arapey", "Unna", "Gilda Display",
    "Marcellus", "Tenor Sans", "Prata", "Rozha One", "Federo",
    "Julius Sans One", "Unica One", "Economica", "Marvel", "Syncopate",
    "Gruppo", "Yanone Kaffeesatz", "Abel", "Pathway Gothic One", "Six Caps",
    "News Cycle", "Marmelad", "Oleo Script", "Rancho", "Spinnaker",
    "Allerta", "Alice", "Brawler", "Cantata One", "Copse",
    "Enriqueta", "Habibi", "Judson", "Kameron", "Linden Hill",
    "Mate", "Neuton", "Ovo", "Petrona", "Quattrocento",
    "Radley", "Rosario", "Tienne", "Vidaloka"
]

fonts = list(set(fonts))

# Check length
print(f"Total unique fonts: {len(fonts)}")

with open("lib/features/styles/styles_screen.dart", "r") as f:
    styles_content = f.read()

# Find all _ThemePreset definitions
preset_pattern = r"_ThemePreset\(([^)]+)\)"
presets = re.findall(preset_pattern, styles_content)

print(f"Total presets found: {len(presets)}")

if len(fonts) < len(presets):
    print("Not enough unique fonts!")
    exit(1)

# Replace each preset's fontFamily with a unique one
new_content = styles_content
for i, preset in enumerate(presets):
    # Find the fontFamily property
    font_pattern = r"fontFamily:\s*'[^']*'"
    new_preset = re.sub(font_pattern, f"fontFamily: '{fonts[i]}'", preset)
    new_content = new_content.replace(preset, new_preset)

with open("lib/features/styles/styles_screen.dart", "w") as f:
    f.write(new_content)

# Update AppFonts.available
appfonts_file = "lib/core/constants/app_fonts.dart"
with open(appfonts_file, "r") as f:
    appfonts_content = f.read()

# Replace the available list
list_str = "[\n" + ",\n".join(f"    '{f}'" for f in fonts) + ",\n  ]"
list_pattern = r"static const List<String> available = \[.*?\];"
appfonts_content = re.sub(list_pattern, f"static const List<String> available = {list_str};", appfonts_content, flags=re.DOTALL)

with open(appfonts_file, "w") as f:
    f.write(appfonts_content)

print("Done replacing fonts.")
