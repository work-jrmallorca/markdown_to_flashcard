import 'package:flutter/material.dart';

class ExceptionDialog extends StatelessWidget {
  final String message;

  const ExceptionDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      icon: Icon(
        Icons.error_outline_rounded,
        size: 80.0,
        color: Theme.of(context).colorScheme.error,
      ),
      content: SingleChildScrollView(
          child: Text(
        message,
        textAlign: TextAlign.center,
      )),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
