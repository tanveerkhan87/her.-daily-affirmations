// a: Import necessary packages
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// b: Import quote category screens
import 'package:her_daily_affirmations/all_quotes/body_positivity.dart';
import 'package:her_daily_affirmations/all_quotes/gratitude_positivity.dart';
import 'package:her_daily_affirmations/all_quotes/time_management.dart';
import 'package:her_daily_affirmations/all_quotes/her_strength.dart';
import 'package:her_daily_affirmations/all_quotes/only_fav.dart';
import 'package:her_daily_affirmations/all_quotes/selflove_Selfcare.dart';
import 'package:her_daily_affirmations/all_quotes/confidence_empowerment.dart';
import '../../all_quotes/Fitness _wellbeing.dart';
import '../../all_quotes/career_leadership.dart';
import '../../all_quotes/financial_mpowerment.dart';
import '../../all_quotes/inspiration_creativity.dart';
import '../../all_quotes/love_realationship.dart';
import '../../all_quotes/mentalhealth_wellbeing.dart';
import '../../all_quotes/motherhood_and_parenting.dart';
import '../../all_quotes/personalgrowth_and_evelopment.dart';

// c: Import providers and home screen
import '../../provider/for_fav/fav_items_provider.dart';
import '../home_screen/home_screen.dart';
import 'categories_item.dart';

// d: Main widget to show category options
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FavItemProvider favItemProvider = FavItemProvider();

  @override
  Widget build(BuildContext context) {
    // e: Theme support (dark/light)
    final ThemeData theme = Theme.of(context);
    final Color appBarBackgroundColor =
    theme.brightness == Brightness.dark ? Colors.white10 : Colors.white;
    final Color textColor =
    theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final Color buttonColor =
    theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 4,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          "Categories",
          style: GoogleFonts.montserratAlternates(
            color: textColor,
            fontSize: 22,
          ),
        ),
        actions: <Widget>[
          // f: Unlock all button (feature placeholder)
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: buttonColor,
            ),
            child: const Text(
              'Unlock All',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            // g: Category items in a grid
            Expanded(
              child: FadeInDown(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/allkind.jpg",
                      paddingTop: 8,
                      title: "All Kinds",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/myfav.jpg",
                      paddingTop: 8,
                      title: "My Favorites",
                      myfunction: () {
                        List<String> selectedQuotes =
                            Provider.of<FavItemProvider>(context, listen: false).selecteditem;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FavoriteQuotes(favoriteQuotes: selectedQuotes),
                          ),
                        );
                      },
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/Self-Love and Self-Care.jpg",
                      title: "Self-Love & \n Self-Care",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SelfLoveSelfCare()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/time management.PNG",
                      title: "Time\nManagement",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const TimeManagement()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/body positive.jpg",
                      title: "Body \nPositivity ",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const BodyPositivity()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/career-and-leadership.PNG",
                      title: "Career & \nLeadership",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CareerAndLeadership()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/confidenceandempowerment.jpg",
                      title: "Confidence &\nEmpowerment",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ConfidenceAndEmpowerment()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/financial empowerment.png",
                      title: " Financial \nEmpowerment",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const FinancialEmpowerment()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/fitness and well being.PNG",
                      title: "Fitness  & \nWell Being",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const FitnessAndWellbeing()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/gratitude and positivity.jpeg.jpg",
                      title: "Gratitude & \n  Positivity",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const GratitudePositivity()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/inspirationandcreativity.jpg",
                      title: "Inspiration & \nCreativity",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Inspirationcreativity()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/mental health and wellbeing.jpg",
                      title: "Mental-Health \n&  Wellbeing",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MentalHealthAndWellbeing()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/motherhood and parenting.jpg",
                      title: "Motherhood & \n Parenting",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MotherhoodAndParenting()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/personal growth and development.jpg",
                      title: "Personal-growth \n& Development",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const PersonalGrowthAndEmpowerment()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/relationship-and-love.png",
                      title: "Love  &\nRelationship",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LoveAndRelationship()),
                      ),
                    ),
                    CategoriesScreenItems(
                      backgroundImage: "assets/images/herstrength.jpg",
                      paddingTop: 8,
                      title: "Her Strength",
                      myfunction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const HerStrength()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
