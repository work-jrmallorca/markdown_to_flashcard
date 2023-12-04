import 'dart:convert';

import 'package:file_picker/file_picker.dart';

import '../../domain/entities/note.dart';
import 'markdown_files_local_data_source.dart';

class PickFilesProxy {
  Future<FilePickerResult?> call() {
    return FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['md', 'txt'],
      allowMultiple: true,
    );
  }
}

class AgnosticOSFilesLocalDataSource implements MarkdownFilesLocalDataSource {
  final PickFilesProxy pickFilesProxy;

  AgnosticOSFilesLocalDataSource({required this.pickFilesProxy});

  @override
  Future<List<Note>?> getFiles() async {
    FilePickerResult? platformFiles = await pickFilesProxy();
    List<Note> notes = [];

    if (platformFiles != null) {
      for (PlatformFile file in platformFiles.files) {
        notes.add(Note(fileContents: utf8.decode(file.bytes!)));
      }
      return notes;
    } else {
      return null;
    }
  }

  @override
  Future<void> updateFile(Note note) {
    // TODO: implement updateFile
    throw UnimplementedError();
  }
}
