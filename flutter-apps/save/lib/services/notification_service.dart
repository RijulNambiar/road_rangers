import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  final Uri launchUri = Uri(scheme: 'save', host: 'app', path: '/login');
  await launchUrl(launchUri, mode: LaunchMode.externalApplication);
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  static Map<int, Map<String, double>> pendingLocations = {};

  Future<void> initializeService() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'accident_channel',
      'Accident Notifications',
      description: 'Notifications for new accidents',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'accident_channel',
        initialNotificationTitle: 'Accident Alert Service',
        initialNotificationContent: 'Running in background',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(),
    );

    await initializeNotifications();
    await service.startService();
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    
    await Supabase.initialize(
      url: 'https://deoyrjkrnruurdtguarl.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRlb3lyamtybnJ1dXJkdGd1YXJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg0ODA0NDMsImV4cCI6MjA1NDA1NjQ0M30.c9ceZ1fWV7mkPYBYYIy2Arcd4UHWgeroRTdlJP4Rkpo',
    );

    final supabase = Supabase.instance.client;
    final notificationService = NotificationService();

    supabase
        .channel('public:accident')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'accident',
          callback: (payload) async {
            debugPrint('New accident inserted in background: $payload');
            await notificationService.showAccidentNotification(payload.newRecord);
          },
        )
        .subscribe();

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  Future<void> showAccidentNotification(Map<String, dynamic> accidentData) async {
    final androidDetails = AndroidNotificationDetails(
      'accident_channel',
      'Accident Notifications',
      channelDescription: 'Notifications for new accidents',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    pendingLocations[notificationId] = {
      'latitude': accidentData['latitude'] as double,
      'longitude': accidentData['longitude'] as double,
    };

    try {
      await flutterLocalNotificationsPlugin.show(
        notificationId,
        'New Accident Reported',
        'Location: (${accidentData['latitude']}, ${accidentData['longitude']})',
        notificationDetails,
        payload: notificationId.toString(),
      );
      debugPrint('Notification sent successfully');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  Future<void> initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final Uri launchUri = Uri(scheme: 'save', host: 'app', path: '/login');
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> openLocationInMap(double latitude, double longitude) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude'
    );
    
    try {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error opening map: $e');
    }
  }
}