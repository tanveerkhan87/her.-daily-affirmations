import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:her_daily_affirmations/provider/hide_quotes/hide_item_provider.dart';
import 'package:her_daily_affirmations/screens/profile/reminder_screen.dart';
import 'package:provider/provider.dart';
import 'package:her_daily_affirmations/provider/for_dark_light_mood/theme_changer.dart';
import 'package:her_daily_affirmations/provider/for_fav/fav_items_provider.dart';
import 'package:her_daily_affirmations/provider/themes/styles_provider.dart';
import 'package:her_daily_affirmations/view/splash_screen.dart';

void main() {
  debugPrint('Navigator Key Assigned: ${ReminderScreen.navigatorKey}');

  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Awesome Notifications with custom channel and icon
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'tanveerkhan123',
        channelName: 'her_daily_affirmations',
        channelDescription: 'Channel for Reminder Notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      ),
    ],
    debug: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, Key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Favorite items state management
        ChangeNotifierProvider(create: (_) => FavItemProvider()),

        // App theme (light/dark mode) management
        ChangeNotifierProvider(create: (_) => ThemeChanger()),

        // Centralized style customization provider
        ChangeNotifierProvider(create: (_) => StyleProvider()),

        // Provider for hiding quotes
        ChangeNotifierProvider(create: (_) => HideProvider()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final themeChanger = Provider.of<ThemeChanger>(context);

          return MaterialApp(
            navigatorKey: ReminderScreen.navigatorKey, // Used to navigate from outside widget tree (e.g., from notifications)
            debugShowCheckedModeBanner: false,

            // Dynamic theming using Provider
            themeMode: themeChanger.themeMode,

            // Light Theme Configuration
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: Brightness.light,
              useMaterial3: false,
            ),

            // Dark Theme Configuration
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),

            // Custom splash screen (replaces Flutter default)
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
