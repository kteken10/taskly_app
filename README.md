# Taskly

<p align="center"><img src="docs/banner.png" alt="Taskly: task manager built with Flutter" width="100%"></p>

![Flutter](https://img.shields.io/badge/Flutter-3-02569B?logo=flutter&logoColor=white)
![Riverpod](https://img.shields.io/badge/state-Riverpod-5A3D80)
![Hive](https://img.shields.io/badge/storage-Hive-FFB300)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-0A2540)

A task manager that keeps you on schedule: deadlines that tell you how much time is left, a reminder one hour before each one, and everything stored on the device.

## Screens

<p align="center"><img src="docs/tour.gif" width="260" alt="Tour of the app: task list, overdue filter, new task, dark mode, French"></p>

| Tasks | Overdue | New task | Dark mode | French |
|:---:|:---:|:---:|:---:|:---:|
| <img src="docs/screens/tasks.png" width="150" alt="Task list"> | <img src="docs/screens/overdue-filter.png" width="150" alt="Overdue filter"> | <img src="docs/screens/new-task.png" width="150" alt="New task dialog"> | <img src="docs/screens/dark-mode.png" width="150" alt="Dark mode"> | <img src="docs/screens/french.png" width="150" alt="French interface"> |

## Features

- **Tasks** with a description, assignee, start date, deadline and a high-priority flag.
- **Status flow**: not started, in progress, completed, with undo and reopen.
- **Time left at a glance**: due today, due tomorrow, due in N days, overdue by how long.
- **Filters** (all, not started, in progress, completed, overdue) and search by name.
- **Reorder** by drag and drop, **swipe to delete** with confirmation.
- **Reminders**: a notification one hour before the deadline, rescheduled when the deadline changes and cancelled when the task is completed or deleted.
- **English and French**, **light and dark themes**, switchable from the app bar.
- **Offline**: tasks are saved on the device with Hive; sample tasks on first launch.

## How it is built

```
lib/
├── model/        Task and TaskStatus, Hive adapters (task.g.dart)
├── providers/    Riverpod notifiers: tasks, theme, locale
├── services/     Hive storage, local notifications, event log
├── screens/      task list screen and filtering
├── ui/           task card, filter bar, add dialog, reorderable list
└── l10n/         English and French strings
test/             model and sample data tests
```

The task notifier is the single place that changes tasks: it saves to Hive and keeps the matching reminder in sync, so the widgets only call it.

## Getting started

```bash
flutter pub get
flutter run
flutter test
```
