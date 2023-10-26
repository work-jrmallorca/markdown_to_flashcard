import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/note_repository.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/add_flashcard_ids_to_note_use_case.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/convert_markdown_to_html_use_case.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/create_or_update_flashcards_in_note_to_ankidroid_use_case.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/markdown_to_flashcard_cubit.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/markdown_to_flashcard_state.dart';
import 'package:mocktail/mocktail.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

class MockConvertMarkdownToHTMLUseCase extends Mock
    implements ConvertMarkdownToHTMLUseCase {}

class MockAddQuestionAnswerPairsInNoteToAnkidroidAndGetIDsUseCase extends Mock
    implements CreateOrUpdateFlashcardsInNoteToAnkidroidUseCase {}

class MockAddFlashcardIDsToNoteUseCase extends Mock
    implements AddFlashcardIDsToNoteUseCase {}

void main() {
  const Note emptyNote = Note(fileContents: '');

  late MockNoteRepository mockNoteRepository;
  late MockConvertMarkdownToHTMLUseCase mockConvertMarkdownToHTMLUseCase;
  late MockAddQuestionAnswerPairsInNoteToAnkidroidAndGetIDsUseCase
      mockAddUseCase;
  late MockAddFlashcardIDsToNoteUseCase mockAddIdsUseCase;
  late MarkdownToFlashcardCubit cubit;

  setUp(() {
    mockNoteRepository = MockNoteRepository();
    mockConvertMarkdownToHTMLUseCase = MockConvertMarkdownToHTMLUseCase();
    mockAddUseCase =
        MockAddQuestionAnswerPairsInNoteToAnkidroidAndGetIDsUseCase();
    mockAddIdsUseCase = MockAddFlashcardIDsToNoteUseCase();

    cubit = MarkdownToFlashcardCubit(
      noteRepository: mockNoteRepository,
      convertMarkdownToHTML: mockConvertMarkdownToHTMLUseCase,
      addQuestionAnswerPairsInNoteToAnkidroidAndGetIDs: mockAddUseCase,
      addFlashcardIDsToNote: mockAddIdsUseCase,
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
        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNote);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNote))
            .thenReturn(expectedNote);
        when(() => mockAddUseCase(expectedNote)).thenAnswer((_) async => []);
        when(() => mockAddIdsUseCase(expectedNote, []))
            .thenReturn(expectedNote);
        when(() => mockNoteRepository.updateNote(expectedNote))
            .thenAnswer((_) async {});
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNote)).called(1);
        verify(() => mockAddUseCase(expectedNote)).called(1);
        verify(() => mockAddIdsUseCase(expectedNote, [])).called(1);
        verify(() => mockNoteRepository.updateNote(expectedNote)).called(1);
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
          when(() => mockNoteRepository.getNote()).thenThrow(exception),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async => verify(() => mockNoteRepository.getNote()).called(1),
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
        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNote);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNote))
            .thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
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
        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNote);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNote))
            .thenReturn(expectedNote);
        when(() => mockAddUseCase(expectedNote)).thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
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
      'GIVEN an exception occurs when note is being added to Ankidroid, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      'THEN throw exception when adding flashcard IDs to note, '
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.failure]',
      setUp: () {
        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNote);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNote))
            .thenReturn(expectedNote);
        when(() => mockAddUseCase(expectedNote)).thenAnswer((_) async => []);
        when(() => mockAddIdsUseCase(expectedNote, [])).thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNote)).called(1);
        verify(() => mockAddUseCase(expectedNote)).called(1);
        verify(() => mockAddIdsUseCase(expectedNote, [])).called(1);
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
      'THEN throw exception when updating the file in the repository, '
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.failure]',
      setUp: () {
        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNote);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNote))
            .thenReturn(expectedNote);
        when(() => mockAddUseCase(expectedNote)).thenAnswer((_) async => []);
        when(() => mockAddIdsUseCase(expectedNote, []))
            .thenReturn(expectedNote);
        when(() => mockNoteRepository.updateNote(expectedNote))
            .thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNote)).called(1);
        verify(() => mockAddUseCase(expectedNote)).called(1);
        verify(() => mockAddIdsUseCase(expectedNote, [])).called(1);
        verify(() => mockNoteRepository.updateNote(expectedNote)).called(1);
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
      setUp: () => when(() => mockNoteRepository.getNote())
          .thenAnswer((_) async => null),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFile(),
      verify: (_) async => verify(() => mockNoteRepository.getNote()).called(1),
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFileStatus.loading),
        const MarkdownToFlashcardState(status: GetMarkdownFileStatus.cancelled),
      ],
    );
  });
}
