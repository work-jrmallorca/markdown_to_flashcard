import 'package:flutter/material.dart';

class ExceptionDialog extends StatelessWidget {
  final String message;

  const ExceptionDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: SingleChildScrollView(child: Text(message)),
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
