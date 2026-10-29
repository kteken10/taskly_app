import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task.dart';
import '../providers/task_provider.dart';
import '../services/analytics_service.dart';
import '../l10n/app_localizations.dart';
import 'animated_task_card.dart';

class ReorderableTaskList extends ConsumerWidget {
  final List<Task> tasks;

  const ReorderableTaskList({required this.tasks, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReorderableListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: Key(task.id),
          background: Container(color: Colors.red),
          secondaryBackground: Container(color: Colors.green),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              return await _showDeleteConfirmation(context);
            } else {
              ref.read(taskProvider.notifier).updateTaskStatus(
                  task.id, 
                  task.status == TaskStatus.Completed 
                    ? TaskStatus.Started 
                    : TaskStatus.Completed);
              return false;
            }
          },
          onDismissed: (_) {
            ref.read(taskProvider.notifier).deleteTask(task.id);
            AnalyticsService.logTaskEvent('delete_task', task);
          },
          child: AnimatedTaskCard(task: task),
        );
      },
      onReorderItem: (oldIndex, newIndex) {
        AnalyticsService.logTaskEvent('reorder_task', tasks[oldIndex]);
        ref.read(taskProvider.notifier).reorderTasks(oldIndex, newIndex);
      },
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).deleteTask),
            content: Text(AppLocalizations.of(context).deleteConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(AppLocalizations.of(context).delete),
              ),
            ],
          ),
        ) ??
        false;
  }
}