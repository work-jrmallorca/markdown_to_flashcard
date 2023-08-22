import 'dart:io';

import 'package:file_picker/file_picker.dart';

// The result will be null, if the user aborted the dialog
class PickMarkdownFile {
  Future<FilePickerResult?> call() async => await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md'],
      );
}

class MarkdownFileRepository {
  final PickMarkdownFile pickMarkdownFileAPI;

  MarkdownFileRepository({required this.pickMarkdownFileAPI});

  Future<File?> getMarkdownFile() async {
    FilePickerResult? result = await pickMarkdownFileAPI();

    return result != null ? File(result.files.first.path!) : null;
  }
}
