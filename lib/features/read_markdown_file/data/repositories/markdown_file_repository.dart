import 'dart:io';

import '../data_sources/markdown_files_local_data_source.dart';

class MarkdownFileRepository {
  final MarkdownFilesLocalDataSource localDataSource;

  MarkdownFileRepository({required this.localDataSource});

  Future<File?> getMarkdownFile() async => await localDataSource.getFile();
}
