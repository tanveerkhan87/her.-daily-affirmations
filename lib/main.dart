import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'shared/providers/favorites_provider.dart';
import 'shared/providers/hidden_quotes_provider.dart';
import 'shared/providers/style_provider.dart';
import 'shared/providers/theme_mode_provider.dart';
import 'shared/providers/category_provider.dart';
import 'features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.tanveerkhan.her_daily_affirmations.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'tanveerkhan123',
        channelName: 'her_daily_affirmations',
        channelDescription: 'Channel for Reminder Notifications',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      ),
    ],
    debug: false,
  );

  runApp(const HerApp());
}

class HerApp extends StatelessWidget {
  const HerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [


        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
        ChangeNotifierProvider(create: (_) => StyleProvider()),
        ChangeNotifierProvider(create: (_) => HiddenQuotesProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: Consumer<ThemeModeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Her Daily Affirmations',
            themeMode: themeProvider.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
