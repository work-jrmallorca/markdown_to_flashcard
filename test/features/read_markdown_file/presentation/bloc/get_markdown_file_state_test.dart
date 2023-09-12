import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/presentation/bloc/get_markdown_file_state.dart';

void main() {
  test('initial state is correct', () {
    const initialState = GetMarkdownFileState();
    expect(initialState.status, GetMarkdownFileStatus.initial);
  });

  test('copyWith works', () {
    const GetMarkdownFileState initialState = GetMarkdownFileState();
    final Exception exception = Exception('Test');
    const Note note = Note(
      fileName: 'Test file name',
      deck: 'Test deck name',
      tags: [],
      questionAnswerPairs: [],
    );

    final state = initialState.copyWith(
      status: GetMarkdownFileStatus.retrieved,
      note: note,
      exception: exception,
    );

    expect(
      state,
      GetMarkdownFileState(
        status: GetMarkdownFileStatus.retrieved,
        note: note,
        exception: exception,
      ),
    );
  });
}
