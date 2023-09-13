import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/markdown_to_flashcard_state.dart';

void main() {
  test('initial state is correct', () {
    const initialState = MarkdownToFlashcardState();
    expect(initialState.status, GetMarkdownFileStatus.initial);
  });

  test('copyWith works', () {
    const MarkdownToFlashcardState initialState = MarkdownToFlashcardState();
    final Exception exception = Exception('Test');
    const Note note = Note(
      fileName: 'Test file name',
      deck: 'Test deck name',
      tags: [],
      questionAnswerPairs: [],
    );

    final state = initialState.copyWith(
      status: GetMarkdownFileStatus.success,
      note: note,
      exception: exception,
    );

    expect(
      state,
      MarkdownToFlashcardState(
        status: GetMarkdownFileStatus.success,
        note: note,
        exception: exception,
      ),
    );
  });
}
