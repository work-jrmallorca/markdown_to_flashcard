import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/markdown_file_repository.dart';

import 'get_markdown_file_state.dart';

class GetMarkdownFileCubit extends Cubit<GetMarkdownFileState> {
  final MarkdownFileRepository repository;

  GetMarkdownFileCubit({required this.repository})
      : super(const GetMarkdownFileState());

  Future<void> getMarkdownFile() async {
    emit(state.copyWith(status: GetMarkdownFileStatus.loading));

    try {
      final File? file = await repository.getMarkdownFile();

      emit(
        state.copyWith(
          status: GetMarkdownFileStatus.success,
          file: file,
        ),
      );
    } on Exception catch (exception) {
      emit(
        state.copyWith(
          status: GetMarkdownFileStatus.failure,
          exception: exception,
        ),
      );
    }
  }
}
