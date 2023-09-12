import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/add_question_answer_pairs_in_note_to_ankidroid_use_case.dart';

import '../../domain/entities/note.dart';
import '../../domain/use_cases/convert_markdown_note_to_dart_note_use_case.dart';
import 'get_markdown_file_state.dart';

class GetMarkdownFileCubit extends Cubit<GetMarkdownFileState> {
  final ConvertMarkdownNoteToDartNoteUseCase convertMarkdownNoteToDartNote;
  final AddQuestionAnswerPairsInNoteToAnkidroidUseCase
      addQuestionAnswerPairsInNoteToAnkidroid;

  GetMarkdownFileCubit({
    required this.convertMarkdownNoteToDartNote,
    required this.addQuestionAnswerPairsInNoteToAnkidroid,
  }) : super(const GetMarkdownFileState());

  Future<void> getMarkdownFile() async {
    emit(state.copyWith(status: GetMarkdownFileStatus.loading));

    try {
      final Note? note = await convertMarkdownNoteToDartNote();

      if (note != null) {
        final List<int> qaPairIds =
            await addQuestionAnswerPairsInNoteToAnkidroid(note);

        emit(
          state.copyWith(
            status: GetMarkdownFileStatus.retrieved,
            note: note,
          ),
        );
      } else {
        emit(state.copyWith(status: GetMarkdownFileStatus.cancelled));
      }
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
