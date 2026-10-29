// lib/services/analytics_service.dart
import 'package:flutter/foundation.dart';
import '../model/task.dart';

class AnalyticsService {
  // Option 1: Stockage en mémoire (simple)
  static final List<Map<String, dynamic>> _events = [];

  // Option 2: Stockage persistant (Hive)

  // Enregistrer un événement
  static Future<void> logTaskEvent(String action, Task task) async {
    final eventData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': action,
      'task_id': task.id,
      'task_status': task.status.toString(),
      'task_title': task.title,
    };

    // Option 1: Journalisation en mémoire
    _events.add(eventData);
    _printEvent(eventData);

    // Option 2: Journalisation persistante (décommentez pour utiliser)
    // await _saveToHive(eventData);
  }

  // Option 1: Affichage dans la console
  static void _printEvent(Map<String, dynamic> event) {
    debugPrint('🔔 Événement analytique:');
    event.forEach((key, value) {
      debugPrint('   $key: $value');
    });
  }

  // Option 2: Sauvegarde dans Hive (nécessite Hive initialisé)
  /*
  static Future<void> _saveToHive(Map<String, dynamic> event) async {
    final box = await Hive.openBox<Map>(_analyticsBoxName);
    await box.add(event);
  }
  */

  // Récupérer les événements (pour affichage dans l'app)
  static List<Map<String, dynamic>> get events => List.unmodifiable(_events);

  // Option 2: Récupérer depuis Hive
  /*
  static Future<List<Map>> getPersistedEvents() async {
    final box = await Hive.openBox<Map>(_analyticsBoxName);
    return box.values.toList();
  }
  */
}