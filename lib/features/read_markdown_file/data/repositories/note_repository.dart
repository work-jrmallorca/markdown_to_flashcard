import '../../domain/entities/note.dart';
import '../data_sources/markdown_files_local_data_source.dart';

class NoteRepository {
  final MarkdownFilesLocalDataSource localDataSource;

  NoteRepository({required this.localDataSource});

  Future<List<Note>> getNote() async => await localDataSource.getFiles();

  Future<void> updateNote(Note note) async =>
      await localDataSource.updateFile(note);
}
