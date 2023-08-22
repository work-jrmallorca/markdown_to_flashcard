import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/bloc/get_markdown_file_state.dart';

void main() {
  test('initial state is correct', () {
    const initialState = GetMarkdownFileState();
    expect(initialState.status, GetMarkdownFileStatus.initial);
  });

  test('copyWith works', () {
    const GetMarkdownFileState initialState = GetMarkdownFileState();
    final Exception exception = Exception('Test');
    final File file = File('test.md');

    final state = initialState.copyWith(
      status: GetMarkdownFileStatus.success,
      file: file,
      exception: exception,
    );

    expect(
      state,
      GetMarkdownFileState(
        status: GetMarkdownFileStatus.success,
        file: file,
        exception: exception,
      ),
    );
  });
}
