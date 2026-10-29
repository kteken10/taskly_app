import 'package:hive/hive.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  DateTime deadline;
  
  @HiveField(4)
  TaskStatus status;

  @HiveField(5)
  final String assignedTo;
  
  @HiveField(6)
  final bool highPriority;

  @HiveField(7)
  DateTime startDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.status = TaskStatus.NotStarted,
    this.assignedTo = '',
    this.highPriority = false,
    DateTime? startDate,
  }) : startDate = startDate ?? deadline;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    TaskStatus? status,
    String? assignedTo,
    bool? highPriority,
    DateTime? startDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      highPriority: highPriority ?? this.highPriority,
      startDate: startDate ?? this.startDate,
    );
  }

  String get formattedDeadline => DateFormat('yyyy-MM-dd').format(deadline);
  String get formattedStartDate => DateFormat('yyyy-MM-dd').format(startDate);

  /// True when the deadline has passed and the task is not completed.
  bool isOverdueAt(DateTime now) => status != TaskStatus.Completed && deadline.isBefore(now);

  /// Calendar days between [now] and the deadline: 0 today, 1 tomorrow.
  int daysUntilDeadline(DateTime now) =>
      DateTime(deadline.year, deadline.month, deadline.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
}

@HiveType(typeId: 1)
enum TaskStatus {
  @HiveField(0)
  // ignore: constant_identifier_names
  NotStarted,
  
  @HiveField(1)
  // ignore: constant_identifier_names
  Started,
  
  @HiveField(2)
  // ignore: constant_identifier_names
  Completed,
}