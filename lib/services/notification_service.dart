import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

/// Local notification service for Sylph app
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  /// Initialize local notifications
  Future<void> initializeNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');

    // iOS initialization settings
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    try {
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      // Create notification channels for Android
      if (Platform.isAndroid) {
        await _createNotificationChannels();
      }

      // Request permissions (iOS)
      if (Platform.isIOS) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }

      print('Notifications initialized successfully');
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  /// Create Android notification channels
  Future<void> _createNotificationChannels() async {
    // Weather alerts channel
    const AndroidNotificationChannel weatherChannel =
        AndroidNotificationChannel(
      'weather_alerts',
      'Weather Alerts',
      description: 'Weather condition alerts and warnings',
      importance: Importance.high,
      enableVibration: true,
      soundSource: RawResourceAndroidNotificationSound('notification'),
    );

    // Air quality channel
    const AndroidNotificationChannel aqiChannel =
        AndroidNotificationChannel(
      'aqi_warnings',
      'Air Quality Warnings',
      description: 'Air quality index and pollution alerts',
      importance: Importance.high,
      enableVibration: true,
      soundSource: RawResourceAndroidNotificationSound('notification'),
    );

    // Reminders channel
    const AndroidNotificationChannel reminderChannel =
        AndroidNotificationChannel(
      'reminders',
      'Reminders',
      description: 'Daily weather reminders',
      importance: Importance.default_,
      enableVibration: false,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(weatherChannel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(aqiChannel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(reminderChannel);
  }

  /// Handle notification tap
  void _handleNotificationTap(NotificationResponse notificationResponse) {
    print('Notification tapped: ${notificationResponse.payload}');
    // Handle navigation or action based on payload
  }

  /// Show weather alert notification
  Future<void> showWeatherAlert({
    required String city,
    required String condition,
    required String description,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'weather_alerts',
      'Weather Alerts',
      channelDescription: 'Weather condition alerts',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'Weather Alert',
    );

    const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      1,
      '🌤️ $condition in $city',
      description,
      platformChannelSpecifics,
      payload: 'weather_alert:$city',
    );

    print('Weather alert shown for $city');
  }

  /// Show air quality warning notification
  Future<void> showAQIWarning({
    required String city,
    required int aqi,
    required String level,
    required String recommendation,
  }) async {
    final String title = _getAQIEmoji(aqi) + ' Air Quality Warning - $city';
    final String body = '$level (AQI: $aqi)\n$recommendation';

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'aqi_warnings',
      'Air Quality Warnings',
      channelDescription: 'Air quality index alerts',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'AQI Alert',
    );

    const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      2,
      title,
      body,
      platformChannelSpecifics,
      payload: 'aqi_warning:$city:$aqi',
    );

    print('AQI warning shown for $city (Level: $level)');
  }

  /// Schedule daily weather reminder
  Future<void> scheduleDailyWeatherNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminders',
      'Reminders',
      channelDescription: 'Daily weather reminders',
      importance: Importance.default_,
      priority: Priority.default_,
    );

    const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAndAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reminder',
    );

    print('Daily reminder scheduled for $hour:$minute');
  }

  /// Show temperature extreme alert
  Future<void> showTemperatureAlert({
    required String city,
    required double temp,
    required String condition,
  }) async {
    final String emoji = temp > 35 ? '🔥' : '❄️';
    final String type = temp > 35 ? 'Heat' : 'Cold';

    await showWeatherAlert(
      city: city,
      condition: '$emoji $type Alert',
      description: 'Temperature: ${temp.toStringAsFixed(1)}°C\n$condition',
    );
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    print('Notification $id cancelled');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('All notifications cancelled');
  }

  // Helper methods

  /// Get AQI emoji based on level
  String _getAQIEmoji(int aqi) {
    if (aqi <= 50) return '✅';
    if (aqi <= 100) return '🟡';
    if (aqi <= 150) return '🟠';
    if (aqi <= 200) return '🔴';
    if (aqi <= 300) return '🟣';
    return '⚫';
  }

  /// Calculate next instance of time
  DateTime _nextInstanceOfTime(int hour, int minute) {
    final DateTime now = DateTime.now();
    DateTime scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
