import '../entities/note.dart';

class AddFlashcardIDsToNoteUseCase {
  Note call(Note note, List<int> ids) {
    RegExp regex = RegExp(r'.* :: .*');

    String newFileContents = note.fileContents.splitMapJoin(
      regex,
      onMatch: (match) => '${match.group(0)}^${ids.removeAt(0)}',
    );

    return note.copyWith(fileContents: newFileContents);
  }
}
