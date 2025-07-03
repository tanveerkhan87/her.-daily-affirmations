import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

// --- Imported Packages ---
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';

// Reminder Model to make the code cleaner
class Reminder {
  final int id;
  final int day; // 1 for Mon, 7 for Sun
  final TimeOfDay time;

  Reminder({required this.id, required this.day, required this.time});

  // Methods to convert to/from a Map for JSON storage
  Map<String, dynamic> toMap() {
    return {'id': id, 'day': day, 'hour': time.hour, 'minute': time.minute};
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      day: map['day'],
      time: TimeOfDay(hour: map['hour'], minute: map['minute']),
    );
  }
}


class ReminderScreen extends StatefulWidget {
  // A global key for the Navigator state, used to handle notification actions.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  // --- Constants for UI and Data ---
  static const List<String> _carouselQuotes = [
    "Don't wait. The time will never be just right.",
    "Your feelings are valid, and so are you.",
    "She's a diamond—precious and unbreakable",
  ];

  static const List<String> _notificationQuotes = [
    "The future belongs to those who believe in the beauty of their dreams.",
    "The only way out of the labyrinth of suffering is to forgive.",
    "The journey of a thousand miles begins with one step.",
    "You have within you right now, everything you need to deal with whatever the world can throw at you.",
  ];

  // --- State Variables ---
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<int> _selectedDays = []; // Stores weekdays for the *next* reminder
  List<Reminder> _scheduledReminders = []; // Stores ALL active reminders

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  /// Initializes the screen, loads saved data, and sets up notification listeners.
  Future<void> _initializeScreen() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
    // Check for permissions and guide user if needed
    await _checkPermissions();
    await _loadRemindersFromPrefs();
  }

  /// Checks if notification permissions are granted.
  Future<void> _checkPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications to remind you.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Don\'t Allow'),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: const Text('Allow'),
              ),
            ],
          ));
    }
  }


  // --- Data Persistence (SharedPreferences) ---

  /// Loads all saved reminders from local storage.
  Future<void> _loadRemindersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = prefs.getStringList('scheduledReminders') ?? [];
    setState(() {
      _scheduledReminders = remindersJson
          .map((json) => Reminder.fromMap(jsonDecode(json)))
          .toList();
    });
  }

  /// Saves the current list of reminders to local storage.
  Future<void> _saveRemindersToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson =
    _scheduledReminders.map((r) => jsonEncode(r.toMap())).toList();
    await prefs.setStringList('scheduledReminders', remindersJson);
  }

  // --- Notification Logic ---

  /// Schedules a new reminder for each selected day and time.
  /// This function now allows for MULTIPLE reminders.
  Future<void> _scheduleNewReminder() async {
    if (_selectedDays.isEmpty) {
      _showInfoDialog('No Days Selected', 'Please select at least one day to schedule a new reminder.');
      return;
    }

    // Schedule a new notification for each selected day
    for (int day in _selectedDays) {
      // Create a unique ID for every single reminder
      final int uniqueId = DateTime.now().millisecondsSinceEpoch % 100000;
      final randomQuote = _notificationQuotes[Random().nextInt(_notificationQuotes.length)];

      final newReminder = Reminder(id: uniqueId, day: day, time: _selectedTime);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: newReminder.id,
          channelKey: 'tanveerkhan123', // Your correct channel key
          title: 'Your Daily Affirmation ✨',
          body: randomQuote,
          payload: {'quote': randomQuote},
          wakeUpScreen: true,
          // CRITICAL: This helps the notification appear on time
          category: NotificationCategory.Reminder,
        ),
        schedule: NotificationCalendar(
          weekday: newReminder.day,
          hour: newReminder.time.hour,
          minute: newReminder.time.minute,
          second: 0,
          millisecond: 0,
          repeats: true, // It will repeat every week on this day and time
          allowWhileIdle: true, // CRITICAL: Allows notification to show when app is closed
        ),
        actionButtons: [
          NotificationActionButton(key: 'VIEW_QUOTE', label: 'View Quote'),
        ],
      );

      _scheduledReminders.add(newReminder);
    }

    // Clear the selections for the next reminder
    setState(() {
      _selectedDays.clear();
    });

    await _saveRemindersToPrefs();
    _showInfoDialog('Success!', 'Your new reminder(s) have been scheduled.');
  }

  /// Cancels a single reminder by its unique ID.
  Future<void> _deleteReminder(int id) async {
    await AwesomeNotifications().cancel(id); // Cancel the notification
    setState(() {
      _scheduledReminders.removeWhere((r) => r.id == id);
    });
    await _saveRemindersToPrefs();
  }

  // --- UI Event Handlers & Build Methods ---

  void _onDayToggled(int weekday) {
    setState(() {
      if (_selectedDays.contains(weekday)) {
        _selectedDays.remove(weekday);
      } else {
        _selectedDays.add(weekday);
        _selectedDays.sort();
      }
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Your Reminders", style: GoogleFonts.montserratAlternates(fontSize: 22, fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            _buildQuoteCarousel(),
            const SizedBox(height: 30),
            _buildSectionTitle("1. Select Day(s) for New Reminder"),
            _buildDaySelector(),
            const SizedBox(height: 30),
            _buildSectionTitle("2. Select Time for New Reminder"),
            _buildTimeSelector(),
            const SizedBox(height: 30),
            _buildScheduleButton(), // This is the "Add Reminder" button now
            const Divider(height: 40, thickness: 1),
            _buildSectionTitle("Active Reminders"),
            _buildRemindersList(),
          ],
        ),
      ),
    );
  }

  // All widget-building methods remain largely the same, but the schedule button's
  // text is changed to be more clear.

  Widget _buildSectionTitle(String title) => Text(title, style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary));

  Widget _buildQuoteCarousel() {
    return CarouselSlider.builder(
      itemCount: _carouselQuotes.length,
      itemBuilder: (context, index, realIndex) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.teal.shade300, Colors.teal.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))]),
        child: Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text(_carouselQuotes[index], style: GoogleFonts.dancingScript(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center))),
      ),
      options: CarouselOptions(height: 150.0, enlargeCenterPage: true, autoPlay: true, autoPlayInterval: const Duration(seconds: 5), autoPlayCurve: Curves.fastOutSlowIn, viewportFraction: 0.85),
    );
  }

  Widget _buildDaySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0, runSpacing: 8.0, alignment: WrapAlignment.center,
        children: List.generate(7, (index) {
          final weekday = index + 1;
          final isSelected = _selectedDays.contains(weekday);
          return ChoiceChip(
            label: Text(_getDayName(weekday)),
            selected: isSelected,
            onSelected: (selected) => _onDayToggled(weekday),
            selectedColor: Colors.teal,
            labelStyle: TextStyle(color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        }),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () => _selectTime(context),
        icon: const Icon(Icons.alarm, color: Colors.white),
        label: Text('Time: ${_selectedTime.format(context)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Widget _buildScheduleButton() {
    return ElevatedButton(
      onPressed: _scheduleNewReminder,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), elevation: 5),
      child: const Text('Add New Reminder', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRemindersList() {
    if (_scheduledReminders.isEmpty) {
      return const Padding(padding: EdgeInsets.all(20.0), child: Text("No reminders scheduled yet.", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center));
    }
    return ListView.builder(
      itemCount: _scheduledReminders.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final reminder = _scheduledReminders[index];
        final dayName = _getDayName(reminder.day);
        final timeString = reminder.time.format(context);

        return FadeInLeft(
          delay: Duration(milliseconds: 100 * index),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Every $dayName at $timeString', style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => _deleteReminder(reminder.id)),
            ),
          ),
        );
      },
    );
  }

  // --- Helper Methods ---

  String _getDayName(int day) => DateFormat('E').format(DateTime(2023, 1, 1 + day));

  void _showInfoDialog(String title, String message) {
    showDialog(context: context, builder: (context) => AlertDialog(title: Text(title), content: Text(message), actions: <Widget>[TextButton(child: const Text('OK'), onPressed: () => Navigator.of(context).pop())]));
  }
}


/// Controller to handle notification actions.
class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'VIEW_QUOTE') {
      final navigatorState = ReminderScreen.navigatorKey.currentState;
      if (navigatorState != null) {
        showDialog(
          context: navigatorState.context,
          builder: (context) => AlertDialog(
            title: const Text('Quote of the Day'),
            content: Text(receivedAction.payload?['quote'] ?? 'No quote available.', style: const TextStyle(fontSize: 18)),
            actions: <Widget>[TextButton(child: const Text('Close'), onPressed: () => Navigator.of(context).pop())],
          ),
        );
      }
    }
  }
}