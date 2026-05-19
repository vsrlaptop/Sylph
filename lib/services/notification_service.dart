import 'package:firebase_messaging/firebase_messaging.dart';

/// Push notification service for Sylph app
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  /// Initialize Firebase Cloud Messaging
  Future<void> initializeNotifications() async {
    try {
      // Request notification permissions (iOS)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carryForward: true,
        critical: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional notification permission');
      } else {
        print('User declined notification permission');
      }

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification!.title}');
          _handleNotification(message);
        }
      });

      // Handle background messages
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        _handleNotification(message);
      });

      // Get FCM token for device
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  /// Handle incoming notification
  void _handleNotification(RemoteMessage message) {
    // Process weather alerts or air quality warnings here
    if (message.data.containsKey('type')) {
      final type = message.data['type'];
      print('Notification type: $type');

      switch (type) {
        case 'weather_alert':
          print('Weather alert: ${message.data['title']}');
          break;
        case 'air_quality_warning':
          print('Air quality warning: ${message.data['aqi']}');
          break;
        default:
          print('Unknown notification type');
      }
    }
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  /// Subscribe to weather alerts topic
  Future<void> subscribeToWeatherAlerts() async {
    try {
      await _firebaseMessaging.subscribeToTopic('weather_alerts');
      print('Subscribed to weather alerts');
    } catch (e) {
      print('Error subscribing to weather alerts: $e');
    }
  }

  /// Subscribe to air quality warnings topic
  Future<void> subscribeToAQIWarnings() async {
    try {
      await _firebaseMessaging.subscribeToTopic('aqi_warnings');
      print('Subscribed to AQI warnings');
    } catch (e) {
      print('Error subscribing to AQI warnings: $e');
    }
  }

  /// Unsubscribe from topics
  Future<void> unsubscribeFromTopics() async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic('weather_alerts');
      await _firebaseMessaging.unsubscribeFromTopic('aqi_warnings');
      print('Unsubscribed from all topics');
    } catch (e) {
      print('Error unsubscribing: $e');
    }
  }
}

/// Background message handler (must be a top-level function)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification!.title}');
  }
}
