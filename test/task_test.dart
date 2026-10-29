import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/model/task.dart';
import 'package:taskly/services/hive_service.dart';

void main() {
  final now = DateTime.now();
  Task task({required Duration due, TaskStatus status = TaskStatus.NotStarted}) =>
      Task(id: '1', title: 'Write report', description: '', deadline: now.add(due), status: status);

  test('start date defaults to the deadline', () {
    final t = task(due: const Duration(days: 2));
    expect(t.startDate, t.deadline);
  });

  test('copyWith changes only the given fields', () {
    final t = task(due: const Duration(days: 2));
    final done = t.copyWith(status: TaskStatus.Completed);
    expect(done.status, TaskStatus.Completed);
    expect(done.title, t.title);
    expect(done.deadline, t.deadline);
  });

  test('deadline is counted in calendar days', () {
    final today = DateTime(2026, 10, 29, 20);
    Task due(DateTime d) => Task(id: '1', title: 't', description: '', deadline: d);
    expect(due(DateTime(2026, 10, 29, 23)).daysUntilDeadline(today), 0);
    expect(due(DateTime(2026, 10, 30, 9)).daysUntilDeadline(today), 1);
    expect(due(DateTime(2026, 11, 2, 9)).daysUntilDeadline(today), 4);
  });

  test('only unfinished tasks past their deadline are overdue', () {
    expect(task(due: const Duration(hours: -5)).isOverdueAt(now), isTrue);
    expect(task(due: const Duration(hours: 5)).isOverdueAt(now), isFalse);
    expect(task(due: const Duration(days: -1), status: TaskStatus.Completed).isOverdueAt(now), isFalse);
  });

  test('sample tasks cover every status, including an overdue one', () {
    final samples = HiveService.sampleTasks(now);
    expect(samples.map((t) => t.id).toSet().length, samples.length);
    expect(samples.map((t) => t.status).toSet(), TaskStatus.values.toSet());
    expect(samples.any((t) => t.isOverdueAt(now)), isTrue);
  });
}
