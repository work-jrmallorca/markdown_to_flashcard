import 'package:flutter/services.dart';

import '../../domain/entities/note.dart';
import 'markdown_files_local_data_source.dart';

class AndroidOSFilesLocalDataSource implements MarkdownFilesLocalDataSource {
  final MethodChannel methodChannel;

  AndroidOSFilesLocalDataSource({required this.methodChannel});

  @override
  Future<List<Note>> getFiles() async {
    List? result = await methodChannel.invokeMethod('pickFiles');
    List<Map<String, String>> files = List.from(result!);
    List<Note> notes = [];

    for (Map<String, String> file in files) {
      notes.add(
        Note(
          uri: file['uri'],
          fileContents: file['fileContents']!,
        ),
      );
    }

    return notes;
  }

  @override
  Future<void> updateFile(Note note) async {
    await methodChannel.invokeMethod(
      'writeFile',
      <String, dynamic>{
        'uri': note.uri,
        'fileContents': note.fileContents,
      },
    );
  }
}
