import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/request_ankidroid_permission_use_case.dart';

import 'features/read_markdown_file/presentation/bloc/markdown_to_flashcard_cubit.dart';
import 'features/read_markdown_file/presentation/get_markdown_file_screen.dart';
import '../../../injection_container.dart' as di;
import 'features/theme/presentation/bloc/theme_cubit.dart';
import 'features/theme/presentation/bloc/theme_state.dart';
import 'features/tutorial/presentation/tutorial_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  di.sl<RequestAnkidroidPermissionUseCase>().call();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MarkdownToFlashcardCubit>(
          create: (_) => di.sl<MarkdownToFlashcardCubit>(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => di.sl<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Markdown to Flashcards',
            theme: state.themeData,
            routerConfig: _router,
          );
        },
      ),
    );
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: ((_, __) => const GetMarkdownFileScreen())),
      GoRoute(path: '/tutorial', builder: ((_, __) => const TutorialScreen()))
    ],
  );
}
