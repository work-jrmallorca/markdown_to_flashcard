import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/markdown_file_picker_local_data_source.dart';

class MarkdownFileRepository {
  final MarkdownFilePickerLocalDataSource localDataSource;

  MarkdownFileRepository({required this.localDataSource});

  Future<File?> getMarkdownFile() async {
    FilePickerResult? result = await localDataSource();

    return result != null ? File(result.files.first.path!) : null;
  }
}
