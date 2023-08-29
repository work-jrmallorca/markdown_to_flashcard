import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/markdown_file_repository.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/get_markdown_file_cubit.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/get_markdown_file_state.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkdownFileRepository extends Mock
    implements MarkdownFileRepository {}

void main() {
  late MockMarkdownFileRepository mock;
  late GetMarkdownFileCubit cubit;

  setUp(() {
    mock = MockMarkdownFileRepository();
    cubit = GetMarkdownFileCubit(repository: mock);
  });

  group('getMarkdownFile()', () {
    final File expected = File('test.md');
    final Exception exception = Exception('Failed to get Markdown file.');

    blocTest<GetMarkdownFileCubit, GetMarkdownFileState>(
      'GIVEN the user successfully selects a Markdown file, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      "THEN call 'getMarkdownFile()' from the repository, "
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.success]',
      setUp: () =>
          when(() => mock.getMarkdownFile()).thenAnswer((_) async => expected),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async => verify(() => mock.getMarkdownFile()).called(1),
      expect: () => <GetMarkdownFileState>[
        const GetMarkdownFileState(status: GetMarkdownFileStatus.loading),
        GetMarkdownFileState(
          status: GetMarkdownFileStatus.success,
          file: expected,
        ),
      ],
    );

    blocTest<GetMarkdownFileCubit, GetMarkdownFileState>(
      'GIVEN an exception occurs when user selects a file, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      "THEN call 'getMarkdownFile()' from the repository, "
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.failure]',
      setUp: () => when(() => mock.getMarkdownFile()).thenThrow(exception),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async => verify(() => mock.getMarkdownFile()).called(1),
      expect: () => <GetMarkdownFileState>[
        const GetMarkdownFileState(status: GetMarkdownFileStatus.loading),
        GetMarkdownFileState(
          status: GetMarkdownFileStatus.failure,
          exception: exception,
        ),
      ],
    );

    blocTest<GetMarkdownFileCubit, GetMarkdownFileState>(
      'GIVEN user cancels selecting a file, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      "THEN call 'getMarkdownFile()' from the repository, "
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.cancelled]',
      setUp: () =>
          when(() => mock.getMarkdownFile()).thenAnswer((_) async => null),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async => verify(() => mock.getMarkdownFile()).called(1),
      expect: () => <GetMarkdownFileState>[
        const GetMarkdownFileState(status: GetMarkdownFileStatus.loading),
        const GetMarkdownFileState(status: GetMarkdownFileStatus.cancelled),
      ],
    );
  });
}
