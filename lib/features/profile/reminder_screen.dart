import 'dart:convert';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/her_app_bar.dart';

// ─── Data Model ────────────────────────────────────────────
class _Reminder {
  final int id;
  final int day;
  final TimeOfDay time;

  const _Reminder({required this.id, required this.day, required this.time});

  Map<String, dynamic> toJson() => {
        'id': id,
        'day': day,
        'hour': time.hour,
        'minute': time.minute,
      };

  factory _Reminder.fromJson(Map<String, dynamic> j) => _Reminder(
        id: j['id'],
        day: j['day'],
        time: TimeOfDay(hour: j['hour'], minute: j['minute']),
      );
}

// ─── Constants ─────────────────────────────────────────────
const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

const _notificationQuotes = [
  "You are worthy of love and respect.",
  "Today is a new beginning, embrace it fully.",
  "You radiate confidence and grace.",
  "Trust the journey, even when the path is unclear.",
  "You are stronger than you think.",
  "Your potential is limitless.",
  "Every step forward is progress.",
  "Believe in your power to create change.",
];

/// Reminder scheduling screen using Awesome Notifications.
class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final Set<int> _selectedDays = {};
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  List<_Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final allowed = await AwesomeNotifications().isNotificationAllowed();
    if (!allowed && mounted) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // ─── Persistence ─────────────────────────────────────────
  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('reminders') ?? [];
    setState(() {
      _reminders = list.map((s) => _Reminder.fromJson(jsonDecode(s))).toList();
    });
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'reminders',
      _reminders.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }

  // ─── Scheduling ──────────────────────────────────────────
  Future<void> _scheduleReminder() async {
    if (_selectedDays.isEmpty) {
      _showInfo('No Days Selected', 'Please select at least one day.');
      return;
    }

    for (final day in _selectedDays) {
      final id = DateTime.now().millisecondsSinceEpoch % 100000 + day;
      final quote = _notificationQuotes[Random().nextInt(_notificationQuotes.length)];
      final reminder = _Reminder(id: id, day: day, time: _selectedTime);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'tanveerkhan123',
          title: 'Your Daily Affirmation',
          body: quote,
          payload: {'quote': quote},
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
        ),
        schedule: NotificationCalendar(
          weekday: day,
          hour: _selectedTime.hour,
          minute: _selectedTime.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          allowWhileIdle: true,
        ),
      );
      _reminders.add(reminder);
    }

    _selectedDays.clear();
    await _saveReminders();
    if (mounted) setState(() {});
    _showInfo('Success!', 'Your reminder(s) have been scheduled.');
  }

  Future<void> _deleteReminder(_Reminder r) async {
    await AwesomeNotifications().cancel(r.id);
    _reminders.remove(r);
    await _saveReminders();
    if (mounted) setState(() {});
  }

  void _showInfo(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HerAppBar(title: 'Reminders'),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingAllMd,
        child: FadeInUp(
          duration: const Duration(milliseconds: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Day Chips ────────────────────
              Text('Select Days', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(7, (i) {
                  final day = i + 1;
                  final selected = _selectedDays.contains(day);
                  return FilterChip(
                    label: Text(_dayNames[i]),
                    selected: selected,
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    onSelected: (v) => setState(() {
                      v ? _selectedDays.add(day) : _selectedDays.remove(day);
                    }),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // ─── Time Picker ──────────────────
              Text('Select Time', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: _selectedTime);
                  if (t != null) setState(() => _selectedTime = t);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.white10 : AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        _selectedTime.format(context),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text('Tap to change', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Schedule Button ──────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _scheduleReminder,
                  icon: const Icon(Icons.notifications_active_rounded),
                  label: const Text('Schedule Reminder'),
                ),
              ),
              const SizedBox(height: 32),

              // ─── Active Reminders ─────────────
              if (_reminders.isNotEmpty) ...[
                Text(
                  'Active Reminders',
                  style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ...List.generate(_reminders.length, (i) {
                  final r = _reminders[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? Colors.white10 : AppColors.divider),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.alarm_rounded, color: AppColors.warning, size: 20),
                        ),
                        title: Text(
                          '${_dayNames[r.day - 1]} at ${r.time.format(context)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                          onPressed: () => _deleteReminder(r),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
