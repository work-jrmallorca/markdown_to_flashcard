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

  setUpAll(() {
    registerFallbackValue(const Note(fileContents: ''));
  });

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
    final Exception exception = Exception('Failed to get Markdown file.');
    late List<Note> expectedNotes;

    setUp(() {
      expectedNotes = [];
    });

    blocTest<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      'GIVEN the user successfully selects multiple Markdown files, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      'THEN call all usecases, '
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.success]',
      setUp: () {
        expectedNotes = expectedNotes
          ..add(emptyNote)
          ..add(emptyNote)
          ..add(emptyNote);

        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNotes);
        when(() => mockConvertMarkdownToHTMLUseCase(any()))
            .thenReturn(emptyNote);
        when(() => mockAddUseCase(any())).thenAnswer((_) async => []);
        when(() => mockAddIdsUseCase(any(), [])).thenReturn(emptyNote);
        when(() => mockNoteRepository.updateNote(any()))
            .thenAnswer((_) async {});
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFiles(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(any())).called(3);
        verify(() => mockAddUseCase(any())).called(3);
        verify(() => mockAddIdsUseCase(any(), [])).called(3);
        verify(() => mockNoteRepository.updateNote(any())).called(3);
      },
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFilesStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFilesStatus.success,
          notes: expectedNotes,
        ),
      ],
    );

    blocTest<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      'GIVEN the user successfully selects a Markdown file, '
      "WHEN 'getMarkdownFile()' is called from the cubit, "
      'THEN call all usecases, '
      'AND emit [GetMarkdownFileStatus.loading, GetMarkdownFileStatus.success]',
      setUp: () {
        expectedNotes = expectedNotes..add(emptyNote);

        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNotes);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .thenReturn(expectedNotes.first);
        when(() => mockAddUseCase(expectedNotes.first))
            .thenAnswer((_) async => []);
        when(() => mockAddIdsUseCase(expectedNotes.first, []))
            .thenReturn(expectedNotes.first);
        when(() => mockNoteRepository.updateNote(expectedNotes.first))
            .thenAnswer((_) async {});
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFiles(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .called(1);
        verify(() => mockAddUseCase(expectedNotes.first)).called(1);
        verify(() => mockAddIdsUseCase(expectedNotes.first, [])).called(1);
        verify(() => mockNoteRepository.updateNote(expectedNotes.first))
            .called(1);
      },
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFilesStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFilesStatus.success,
          notes: expectedNotes,
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
      act: (cubit) => cubit.getMarkdownFiles(),
      verify: (_) async => verify(() => mockNoteRepository.getNote()).called(1),
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFilesStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFilesStatus.failure,
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
        expectedNotes = expectedNotes..add(emptyNote);

        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNotes);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFiles(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .called(1);
      },
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFilesStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFilesStatus.failure,
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
        expectedNotes = expectedNotes..add(emptyNote);

        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNotes);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .thenReturn(expectedNotes.first);
        when(() => mockAddUseCase(expectedNotes.first)).thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFiles(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .called(1);
        verify(() => mockAddUseCase(expectedNotes.first)).called(1);
      },
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFilesStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFilesStatus.failure,
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
        expectedNotes = expectedNotes..add(emptyNote);

        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNotes);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .thenReturn(expectedNotes.first);
        when(() => mockAddUseCase(expectedNotes.first))
            .thenAnswer((_) async => []);
        when(() => mockAddIdsUseCase(expectedNotes.first, []))
            .thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFiles(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .called(1);
        verify(() => mockAddUseCase(expectedNotes.first)).called(1);
        verify(() => mockAddIdsUseCase(expectedNotes.first, [])).called(1);
      },
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFilesStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFilesStatus.failure,
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
        expectedNotes = expectedNotes..add(emptyNote);

        when(() => mockNoteRepository.getNote())
            .thenAnswer((_) async => expectedNotes);
        when(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .thenReturn(expectedNotes.first);
        when(() => mockAddUseCase(expectedNotes.first))
            .thenAnswer((_) async => []);
        when(() => mockAddIdsUseCase(expectedNotes.first, []))
            .thenReturn(expectedNotes.first);
        when(() => mockNoteRepository.updateNote(expectedNotes.first))
            .thenThrow(exception);
      },
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFiles(),
      verify: (_) async {
        verify(() => mockNoteRepository.getNote()).called(1);
        verify(() => mockConvertMarkdownToHTMLUseCase(expectedNotes.first))
            .called(1);
        verify(() => mockAddUseCase(expectedNotes.first)).called(1);
        verify(() => mockAddIdsUseCase(expectedNotes.first, [])).called(1);
        verify(() => mockNoteRepository.updateNote(expectedNotes.first))
            .called(1);
      },
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFilesStatus.loading),
        MarkdownToFlashcardState(
          status: GetMarkdownFilesStatus.failure,
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
          .thenAnswer((_) async => expectedNotes),
      build: () => cubit,
      act: (cubit) => cubit.getMarkdownFiles(),
      verify: (_) async => verify(() => mockNoteRepository.getNote()).called(1),
      expect: () => <MarkdownToFlashcardState>[
        const MarkdownToFlashcardState(status: GetMarkdownFilesStatus.loading),
        const MarkdownToFlashcardState(
            status: GetMarkdownFilesStatus.cancelled),
      ],
    );
  });
}
