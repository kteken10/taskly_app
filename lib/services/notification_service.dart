import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import '../model/task.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'task_channel';
  static const String _channelName = 'Task Reminders';
  static const String _channelDescription = 'Notifications for task reminders';

  // Initialisation du service de notifications
  static Future<void> initialize() async {
    await _setupTimeZones();
    await _initializeNotificationPlugin();
    await _createNotificationChannel();
    await _android?.requestNotificationsPermission();
  }

  static AndroidFlutterLocalNotificationsPlugin? get _android => _notificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  static Future<void> _setupTimeZones() async {
    // Les échéances sont converties en instants UTC : le fuseau de l'appareil n'a pas d'importance.
    tz.initializeTimeZones();
  }

  static Future<void> _initializeNotificationPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      playSound: true,
      showBadge: true,
    );

    await _android?.createNotificationChannel(channel);
  }

  static void _onNotificationTap(NotificationResponse notificationResponse) {
    // Gérer le clic sur la notification si nécessaire
  }

  // Planifier une notification pour une tâche
  static Future<void> scheduleTaskNotification(Task task) async {
    try {
      final scheduledDate = _getNotificationTime(task.deadline);
      if (scheduledDate.isBefore(DateTime.now())) return;
      await _notificationsPlugin.zonedSchedule(
        task.id.hashCode,
        'Task reminder',
        '"${task.title}" is due in one hour.',
        scheduledDate,
        _buildNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: task.id, // Peut être utilisé pour naviguer vers la tâche
      );
    } catch (e) {
      debugPrint('Erreur lors de la planification de la notification: $e');
    }
  }

  static tz.TZDateTime _getNotificationTime(DateTime deadline) {
    final notificationTime = deadline.subtract(const Duration(hours: 1));
    return tz.TZDateTime.from(notificationTime, tz.UTC);
  }

  static NotificationDetails _buildNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
    );
  }

  // Annuler une notification pour une tâche
  static Future<void> cancelNotification(Task task) async {
    await _notificationsPlugin.cancel(task.id.hashCode);
  }

  // Annuler toutes les notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Vérifier si une notification est planifiée pour une tâche
  static Future<bool> isNotificationScheduled(Task task) async {
    final pendingNotifications = await _notificationsPlugin.pendingNotificationRequests();
    return pendingNotifications.any((notification) => notification.id == task.id.hashCode);
  }

  // Mettre à jour la notification d'une tâche (annule et recrée)
  static Future<void> updateTaskNotification(Task task) async {
    await cancelNotification(task);
    if (task.status != TaskStatus.Completed) {
      await scheduleTaskNotification(task);
    }
  }
}