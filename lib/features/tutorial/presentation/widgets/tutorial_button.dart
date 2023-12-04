import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialButton extends StatelessWidget {
  const TutorialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Open navigation menu',
      icon: const Icon(Icons.question_mark_rounded),
      onPressed: () => context.go('/tutorial'),
    );
  }
}
