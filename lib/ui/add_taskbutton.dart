import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AddTaskButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddTaskButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: onPressed,
        tooltip: AppLocalizations.of(context).addTask,
      ),
    );
  }
}