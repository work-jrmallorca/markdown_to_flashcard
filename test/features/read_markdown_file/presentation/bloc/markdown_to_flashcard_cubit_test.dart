import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/add_question_answer_pairs_in_note_to_ankidroid_use_case.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/convert_markdown_note_to_dart_note_use_case.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/convert_markdown_to_html_use_case.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/markdown_to_flashcard_cubit.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/markdown_to_flashcard_state.dart';
import 'package:mocktail/mocktail.dart';

class MockConvertMarkdownNoteToDartNoteUseCase extends Mock
    implements ConvertMarkdownNoteToDartNoteUseCase {}

class MockConvertMarkdownToHTMLUseCase extends Mock
    implements ConvertMarkdownToHTMLUseCase {}

class MockAddQuestionAnswerPairsInNoteToAnkidroidUseCase extends Mock
    implements AddQuestionAnswerPairsInNoteToAnkidroidUseCase {}

void main() {
  const Note emptyNote = Note(
    fileName: 'Test file name',
    deck: 'Test deck name',
    tags: [],
    questionAnswerPairs: [],
  );

  late MockConvertMarkdownNoteToDartNoteUseCase mockConvertFileToDartUseCase;
  late MockConvertMarkdownToHTMLUseCase mockConvertMarkdownToHTMLUseCase;
  late MockAddQuestionAnswerPairsInNoteToAnkidroidUseCase mockAddUseCase;
  late MarkdownToFlashcardCubit cubit;

  setUp(() {
    mockConvertFileToDartUseCase = MockConvertMarkdownNoteToDartNoteUseCase();
    mockConvertMarkdownToHTMLUseCase = MockConvertMarkdownToHTMLUseCase();
    mockAddUseCase = MockAddQuestionAnswerPairsInNoteToAnkidroidUseCase();
    cubit = MarkdownToFlashcardCubit(
      convertMarkdownNoteToDartNote: mockConvertFileToDartUseCase,
      convertMarkdownToHTMLUseCase: mockConvertMarkdownToHTMLUseCase,
      addQuestionAnswerPairsInNoteToAnkidroid: mockAddUseCase,
    );
  });

  group('getMarkdownFile()', () {
    const Note expectedNote = emptyNote;
    final Exception exception = Exception('Failed to get Markdown file.');

    blocTest<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      'GIVEN the user successfully selects a Markdown file, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      'THEN call all usecases, '
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.success]',
      setUp: () {
        when(() => mockConvertFileToDartUseCase())
            .thenAnswer((_) async => expectedNote);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNote))
            .thenReturn(expectedNote);
        when(() => mockAddUseCase(expectedNote)).thenAnswer((_) async {});
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async {
        verify(() => mockConvertFileToDartUseCase()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNote)).called(1);
        verify(() => mockAddUseCase(expectedNote)).called(1);
      },
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFileStatus.loading),
        const MarkdownToFlashcardState(
          status: GetMarkdownFileStatus.success,
          note: expectedNote,
        ),
      ],
    );

    blocTest<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      'GIVEN an exception occurs when user selects a file, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      'THEN throw exception when converting file to PODO, '
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.failure]',
      setUp: () =>
          when(() => mockConvertFileToDartUseCase()).thenThrow(exception),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async =>
          verify(() => mockConvertFileToDartUseCase()).called(1),
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFileStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFileStatus.failure,
          exception: exception,
        ),
      ],
    );

    blocTest<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      'GIVEN an exception occurs when markdown is being converted to HTML, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      'THEN throw exception when converting markdown to HTML, '
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.failure]',
      setUp: () {
        when(() => mockConvertFileToDartUseCase())
            .thenAnswer((_) async => expectedNote);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNote))
            .thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async {
        verify(() => mockConvertFileToDartUseCase()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNote)).called(1);
      },
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFileStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFileStatus.failure,
          exception: exception,
        ),
      ],
    );

    blocTest<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      'GIVEN an exception occurs when note is being added to Ankidroid, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      'THEN throw exception when adding note to Ankidroid, '
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.failure]',
      setUp: () {
        when(() => mockConvertFileToDartUseCase())
            .thenAnswer((_) async => expectedNote);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNote))
            .thenReturn(expectedNote);
        when(() => mockAddUseCase(expectedNote)).thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async {
        verify(() => mockConvertFileToDartUseCase()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNote)).called(1);
        verify(() => mockAddUseCase(expectedNote)).called(1);
      },
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFileStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFileStatus.failure,
          exception: exception,
        ),
      ],
    );

    blocTest<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      'GIVEN user cancels selecting a file, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      "THEN call 'getMarkdownFile()' from the repository, "
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.cancelled]',
      setUp: () => when(() => mockConvertFileToDartUseCase())
          .thenAnswer((_) async => null),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async =>
          verify(() => mockConvertFileToDartUseCase()).called(1),
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFileStatus.loading),
        const MarkdownToFlashcardState(status: GetMarkdownFileStatus.cancelled),
      ],
    );
  });
}
