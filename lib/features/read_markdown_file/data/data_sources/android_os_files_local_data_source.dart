import 'package:flutter/services.dart';

import '../../domain/entities/note.dart';
import 'markdown_files_local_data_source.dart';

class AndroidOSFilesLocalDataSource implements MarkdownFilesLocalDataSource {
  final MethodChannel methodChannel;

  AndroidOSFilesLocalDataSource({required this.methodChannel});

  @override
  Future<Note?> getFile() async {
    Map? result = await methodChannel.invokeMethod('pickFile');

    if (result != null) {
      Map<String, String> file = Map.from(result);

      return Note(
        uri: file['uri'],
        fileContents: file['fileContents']!,
      );
    } else {
      return null;
    }
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
