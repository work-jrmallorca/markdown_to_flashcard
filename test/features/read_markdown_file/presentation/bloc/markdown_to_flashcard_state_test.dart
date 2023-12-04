import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/markdown_to_flashcard_state.dart';

void main() {
  test('initial state is correct', () {
    const initialState = MarkdownToFlashcardState();
    expect(initialState.status, GetMarkdownFilesStatus.initial);
  });

  test('copyWith works', () {
    const MarkdownToFlashcardState initialState = MarkdownToFlashcardState();
    const String errorMessage = 'Test';
    const List<Note> notes = [Note(fileContents: '')];

    final state = initialState.copyWith(
      status: GetMarkdownFilesStatus.success,
      notes: notes,
      errorMessage: errorMessage,
    );

    expect(
      state,
      const MarkdownToFlashcardState(
        status: GetMarkdownFilesStatus.success,
        notes: notes,
        errorMessage: errorMessage,
      ),
    );
  });
}
