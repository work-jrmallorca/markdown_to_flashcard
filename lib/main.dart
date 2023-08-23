import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/get_markdown_file_cubit.dart';

import 'features/read_markdown_file/presentation/get_markdown_file_screen.dart';
import '../../../injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<GetMarkdownFileCubit>(),
      child: const MaterialApp(
        title: 'Markdown to Flashcards',
        home: GetMarkdownFileScreen(),
      ),
    );
  }
}
