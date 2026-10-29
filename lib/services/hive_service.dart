import 'package:hive_flutter/hive_flutter.dart';

import '../model/task.dart';

class HiveService {
  static const _taskBoxName = 'tasks';
  static const _settingsBoxName = 'settings';

  Future<void> init() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskStatusAdapter());
    }
    
    final tasks = await Hive.openBox<Task>(_taskBoxName);
    final settings = await Hive.openBox(_settingsBoxName);
    if (settings.get('seeded') != true) {
      if (tasks.isEmpty) await tasks.addAll(sampleTasks(DateTime.now()));
      await settings.put('seeded', true);
    }
  }

  /// Tasks shown on first launch so the app is never empty.
  static List<Task> sampleTasks(DateTime now) {
    DateTime at(int days, int hour) => DateTime(now.year, now.month, now.day + days, hour);
    return [
      Task(id: 'sample-1', title: 'Prepare sprint review', description: 'Slides and demo of the new onboarding.', deadline: at(1, 10), startDate: at(-1, 9), status: TaskStatus.Started, assignedTo: 'Kevin', highPriority: true),
      Task(id: 'sample-2', title: 'Fix login on Android 14', description: 'Crash when the keyboard opens on the password field.', deadline: at(0, 18), startDate: at(0, 9), status: TaskStatus.Started, highPriority: true),
      Task(id: 'sample-3', title: 'Write release notes', description: 'Version 1.4: dark mode, French translation, reminders.', deadline: at(3, 12), startDate: at(2, 9)),
      Task(id: 'sample-4', title: 'Update app screenshots', description: 'Store listing in English and French.', deadline: at(-1, 17), startDate: at(-3, 9)),
      Task(id: 'sample-5', title: 'Code review: payment module', description: 'Check error handling and tests.', deadline: at(-2, 16), startDate: at(-3, 10), status: TaskStatus.Completed),
      Task(id: 'sample-6', title: 'Plan team offsite', description: 'Venue, agenda and budget.', deadline: at(7, 9), startDate: at(5, 9)),
    ];
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final box = Hive.box<Task>(_taskBoxName);
    await box.clear();
    await box.addAll(tasks);
  }

  List<Task> getTasks() {
    return Hive.box<Task>(_taskBoxName).values.toList();
  }
}