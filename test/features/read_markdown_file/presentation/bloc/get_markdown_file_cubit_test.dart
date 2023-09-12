import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/add_question_answer_pairs_in_note_to_ankidroid_use_case.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/convert_markdown_note_to_dart_note_use_case.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/get_markdown_file_cubit.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/get_markdown_file_state.dart';
import 'package:mocktail/mocktail.dart';

class MockConvertMarkdownNoteToDartNoteUseCase extends Mock
    implements ConvertMarkdownNoteToDartNoteUseCase {}

class MockAddQuestionAnswerPairsInNoteToAnkidroidUseCase extends Mock
    implements AddQuestionAnswerPairsInNoteToAnkidroidUseCase {}

void main() {
  const Note emptyNote = Note(
    fileName: 'Test file name',
    deck: 'Test deck name',
    tags: [],
    questionAnswerPairs: [],
  );

  late MockConvertMarkdownNoteToDartNoteUseCase mockConvertUseCase;
  late MockAddQuestionAnswerPairsInNoteToAnkidroidUseCase mockAddUseCase;
  late GetMarkdownFileCubit cubit;

  setUp(() {
    mockConvertUseCase = MockConvertMarkdownNoteToDartNoteUseCase();
    mockAddUseCase = MockAddQuestionAnswerPairsInNoteToAnkidroidUseCase();
    cubit = GetMarkdownFileCubit(
      convertMarkdownNoteToDartNote: mockConvertUseCase,
      addQuestionAnswerPairsInNoteToAnkidroid: mockAddUseCase,
    );
  });

  group('getMarkdownFile()', () {
    const Note expectedNote = emptyNote;
    const List<int> expectedNoteIds = [];
    final Exception exception = Exception('Failed to get Markdown file.');

    blocTest<GetMarkdownFileCubit, GetMarkdownFileState>(
      'GIVEN the user successfully selects a Markdown file, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      "THEN call 'getMarkdownFile()' from the repository, "
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.success]',
      setUp: () {
        when(() => mockConvertUseCase()).thenAnswer((_) async => expectedNote);
        when(() => mockAddUseCase(expectedNote))
            .thenAnswer((_) async => expectedNoteIds);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async => verify(() => mockConvertUseCase()).called(1),
      expect: () => <GetMarkdownFileState>[
        const GetMarkdownFileState(status: GetMarkdownFileStatus.loading),
        const GetMarkdownFileState(
          status: GetMarkdownFileStatus.retrieved,
          note: expectedNote,
        ),
      ],
    );

    blocTest<GetMarkdownFileCubit, GetMarkdownFileState>(
      'GIVEN an exception occurs when user selects a file, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      "THEN call 'getMarkdownFile()' from the repository, "
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.failure]',
      setUp: () => when(() => mockConvertUseCase()).thenThrow(exception),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async => verify(() => mockConvertUseCase()).called(1),
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
          when(() => mockConvertUseCase()).thenAnswer((_) async => null),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async => verify(() => mockConvertUseCase()).called(1),
      expect: () => <GetMarkdownFileState>[
        const GetMarkdownFileState(status: GetMarkdownFileStatus.loading),
        const GetMarkdownFileState(status: GetMarkdownFileStatus.cancelled),
      ],
    );
  });
}
