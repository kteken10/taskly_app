import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super(HiveService().getTasks());

  void addTask(Task task) {
    state = [...state, task];
    _saveToHive();
    NotificationService.updateTaskNotification(task);
  }

  void updateTaskStatus(String taskId, TaskStatus newStatus) {
    state = state.map((task) {
      if (task.id == taskId) {
        return task.copyWith(
          status: newStatus,
          startDate: newStatus == TaskStatus.Started 
              ? DateTime.now() 
              : task.startDate,
        );
      }
      return task;
    }).toList();
    _saveToHive();
    _syncReminder(taskId);
  }

  void updateDeadline(String taskId, DateTime newDeadline) {
    state = state.map((task) {
      if (task.id == taskId) return task.copyWith(deadline: newDeadline);
      return task;
    }).toList();
    _saveToHive();
    _syncReminder(taskId);
  }

  void updateStartDate(String taskId, DateTime newStartDate) {
    state = state.map((task) {
      if (task.id == taskId) return task.copyWith(startDate: newStartDate);
      return task;
    }).toList();
    _saveToHive();
  }

  void deleteTask(String taskId) {
    for (final task in state.where((task) => task.id == taskId)) {
      NotificationService.cancelNotification(task);
    }
    state = state.where((task) => task.id != taskId).toList();
    _saveToHive();
  }

  /// [newIndex] is the final position, already adjusted for the removed item.
  void reorderTasks(int oldIndex, int newIndex) {
    final tasks = [...state];
    tasks.insert(newIndex, tasks.removeAt(oldIndex));
    state = tasks;
    _saveToHive();
  }

  /// Reminder one hour before the deadline, cancelled once the task is completed.
  void _syncReminder(String taskId) {
    for (final task in state.where((task) => task.id == taskId)) {
      NotificationService.updateTaskNotification(task);
    }
  }

  void _saveToHive() {
    HiveService().saveTasks(state);
  }
}