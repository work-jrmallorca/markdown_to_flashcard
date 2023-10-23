import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/read_markdown_file/data/data_sources/agnostic_os_files_local_data_source.dart';
import 'features/read_markdown_file/data/repositories/note_repository.dart';
import 'features/read_markdown_file/domain/use_cases/add_question_answer_pairs_in_note_to_ankidroid_use_case.dart';
import 'features/read_markdown_file/domain/use_cases/convert_markdown_to_html_use_case.dart';
import 'features/read_markdown_file/domain/use_cases/request_ankidroid_permission_use_case.dart';
import 'features/read_markdown_file/presentation/bloc/markdown_to_flashcard_cubit.dart';
import 'features/theme/data/data_sources/theme_local_data_source.dart';
import 'features/theme/data/repositories/theme_repository.dart';
import 'features/theme/presentation/bloc/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  sl.registerFactory(
    () => MarkdownToFlashcardCubit(
      noteRepository: sl(),
      convertMarkdownToHTMLUseCase: sl(),
      addQuestionAnswerPairsInNoteToAnkidroid: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => RequestAnkidroidPermissionUseCase(
      methodChannel: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => ConvertMarkdownToHTMLUseCase(),
  );

  sl.registerLazySingleton(
    () => AddQuestionAnswerPairsInNoteToAnkidroidUseCase(
      methodChannel: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => NoteRepository(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => AgnosticOSFilesLocalDataSource(
      pickFiles: sl(),
    ),
  );

  sl.registerLazySingleton(() => PickFilesProxy());

  // Theme
  sl.registerFactory(() => ThemeCubit(repository: sl()));

  sl.registerLazySingleton(
    () => ThemeRepository(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => ThemeLocalDataSource(
      key: 'themeStatus',
      preferences: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton(
    () => const MethodChannel('app.jrmallorca.markdown_to_flashcard/ankidroid'),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
