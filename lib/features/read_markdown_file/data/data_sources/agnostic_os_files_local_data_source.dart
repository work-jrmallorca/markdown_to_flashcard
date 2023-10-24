import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/entities/note_entity.dart';

import 'markdown_files_local_data_source.dart';

class PickFilesProxy {
  Future<FilePickerResult?> call() {
    return FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['md', 'txt'],
    );
  }
}

class AgnosticOSFilesLocalDataSource implements MarkdownFilesLocalDataSource {
  final PickFilesProxy pickFiles;

  AgnosticOSFilesLocalDataSource({required this.pickFiles});

  @override
  Future<NoteEntity?> getFile() async {
    FilePickerResult? result = await pickFiles();
    if (result != null) {
      return NoteEntity(
        fileContents: utf8.decode(result.files.first.bytes!),
      );
    } else {
      return null;
    }
  }
}
