import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note.dart';
import '../../domain/use_cases/convert_markdown_note_to_dart_note_use_case.dart';
import 'get_markdown_file_state.dart';

class GetMarkdownFileCubit extends Cubit<GetMarkdownFileState> {
  final ConvertMarkdownNoteToDartNoteUseCase convertMarkdownNoteToDartNote;

  GetMarkdownFileCubit({required this.convertMarkdownNoteToDartNote})
      : super(const GetMarkdownFileState());

  Future<void> getMarkdownFile() async {
    emit(state.copyWith(status: GetMarkdownFileStatus.loading));

    try {
      final Note? note = await convertMarkdownNoteToDartNote();

      note != null
          ? emit(
              state.copyWith(
                status: GetMarkdownFileStatus.retrieved,
                note: note,
              ),
            )
          : emit(state.copyWith(status: GetMarkdownFileStatus.cancelled));
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
