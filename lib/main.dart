import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/request_ankidroid_permission_use_case.dart';

import 'features/read_markdown_file/presentation/bloc/markdown_to_flashcard_cubit.dart';
import 'features/read_markdown_file/presentation/get_markdown_file_screen.dart';
import '../../../injection_container.dart' as di;
import 'features/theme/presentation/bloc/theme_cubit.dart';
import 'features/theme/presentation/bloc/theme_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  di.sl<RequestAnkidroidPermissionUseCase>().call();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MarkdownToFlashcardCubit>(
          create: (_) => di.sl<MarkdownToFlashcardCubit>(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Markdown to Flashcards',
            theme: state.themeData,
            home: const GetMarkdownFileScreen(),
          );
        },
      ),
    );
  }
}
