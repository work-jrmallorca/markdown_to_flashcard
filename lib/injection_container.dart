import 'package:get_it/get_it.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/markdown_file_picker_local_data_source.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/markdown_file_repository.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/get_markdown_file_cubit.dart';

final sl = GetIt.instance;

void init() {
  // Features
  sl.registerFactory(
    () => GetMarkdownFileCubit(repository: sl()),
  );

  sl.registerLazySingleton(
    () => MarkdownFileRepository(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => MarkdownFilePickerLocalDataSource(),
  );

  // Core

  // External
}
