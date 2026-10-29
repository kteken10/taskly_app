import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'taskList': 'Task List',
      'addTask': 'Add Task',
      'addTaskSubtitle': 'Fill in the task details',
      'title': 'Title',
      'titleRequired': 'A title is required',
      'description': 'Description',
      'assignedTo': 'Assigned to',
      'highPriority': 'High priority',
      'deadline': 'Deadline',
      'cancel': 'Cancel',
      'add': 'Add',
      'startTask': 'Start Task',
      'markComplete': 'Mark Complete',
      'revert': 'Revert',
      'reopen': 'Reopen',
      'noTasks': 'No tasks found',
      'filterTasks': 'Filter tasks:',
      'search': 'Search by name...',
      'all': 'All',
      'notStarted': 'Not Started',
      'inProgress': 'In Progress',
      'completed': 'Completed',
      'overdue': 'Overdue',
      'start': 'Start',
      'editDeadline': 'Edit deadline',
      'editStartDate': 'Edit start date',
      'deleteTask': 'Delete Task',
      'deleteConfirm': 'Are you sure you want to delete this task?',
      'delete': 'Delete',
      'dueToday': 'Due today',
    },
    'fr': {
      'taskList': 'Mes tâches',
      'addTask': 'Nouvelle tâche',
      'addTaskSubtitle': 'Renseigne les détails de la tâche',
      'title': 'Titre',
      'titleRequired': 'Le titre est requis',
      'description': 'Description',
      'assignedTo': 'Assignée à',
      'highPriority': 'Priorité haute',
      'deadline': 'Échéance',
      'cancel': 'Annuler',
      'add': 'Ajouter',
      'startTask': 'Commencer',
      'markComplete': 'Terminer',
      'revert': 'Retour',
      'reopen': 'Rouvrir',
      'noTasks': 'Aucune tâche trouvée',
      'filterTasks': 'Filtrer :',
      'search': 'Rechercher par nom...',
      'all': 'Toutes',
      'notStarted': 'À faire',
      'inProgress': 'En cours',
      'completed': 'Terminées',
      'overdue': 'En retard',
      'start': 'Début',
      'editDeadline': "Modifier l'échéance",
      'editStartDate': 'Modifier la date de début',
      'deleteTask': 'Supprimer la tâche',
      'deleteConfirm': 'Veux-tu vraiment supprimer cette tâche ?',
      'delete': 'Supprimer',
      'dueToday': "Pour aujourd'hui",
    },
  };

  String _t(String key) => _localizedValues[locale.languageCode]![key]!;
  bool get _fr => locale.languageCode == 'fr';

  String get taskList => _t('taskList');
  String get addTask => _t('addTask');
  String get addTaskSubtitle => _t('addTaskSubtitle');
  String get title => _t('title');
  String get titleRequired => _t('titleRequired');
  String get description => _t('description');
  String get assignedTo => _t('assignedTo');
  String get highPriority => _t('highPriority');
  String get deadline => _t('deadline');
  String get cancel => _t('cancel');
  String get add => _t('add');
  String get startTask => _t('startTask');
  String get markComplete => _t('markComplete');
  String get revert => _t('revert');
  String get reopen => _t('reopen');
  String get noTasks => _t('noTasks');
  String get filterTasks => _t('filterTasks');
  String get search => _t('search');
  String get all => _t('all');
  String get notStarted => _t('notStarted');
  String get inProgress => _t('inProgress');
  String get completed => _t('completed');
  String get overdue => _t('overdue');
  String get editDeadline => _t('editDeadline');
  String get editStartDate => _t('editStartDate');
  String get deleteTask => _t('deleteTask');
  String get deleteConfirm => _t('deleteConfirm');
  String get delete => _t('delete');
  String get dueToday => _t('dueToday');

  String shortDate(DateTime date) => DateFormat('MMM d', locale.languageCode).format(date);
  String startOn(DateTime date) => '${_t('start')}: ${shortDate(date)}';
  String completedOn(DateTime date) => _fr ? 'Terminée le ${shortDate(date)}' : 'Completed: ${shortDate(date)}';
  String overdueBy(Duration d) => _fr
      ? 'Retard ${d.inHours} h ${d.inMinutes % 60}'
      : 'Overdue - ${d.inHours}h ${d.inMinutes % 60}m';
  String dueInDays(int days) => days == 1
      ? (_fr ? 'Pour demain' : 'Due tomorrow')
      : (_fr ? 'Dans $days jours' : 'Due in $days days');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
