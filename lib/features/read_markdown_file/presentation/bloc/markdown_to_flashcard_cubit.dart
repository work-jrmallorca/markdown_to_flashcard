import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/note_repository.dart';
import '../../domain/entities/note.dart';
import '../../domain/use_cases/add_question_answer_pairs_in_note_to_ankidroid_use_case.dart';
import '../../domain/use_cases/convert_markdown_to_html_use_case.dart';
import 'markdown_to_flashcard_state.dart';

class MarkdownToFlashcardCubit extends Cubit<MarkdownToFlashcardState> {
  final NoteRepository noteRepository;
  final ConvertMarkdownToHTMLUseCase convertMarkdownToHTMLUseCase;
  final AddQuestionAnswerPairsInNoteToAnkidroidUseCase
      addQuestionAnswerPairsInNoteToAnkidroid;

  MarkdownToFlashcardCubit({
    required this.noteRepository,
    required this.convertMarkdownToHTMLUseCase,
    required this.addQuestionAnswerPairsInNoteToAnkidroid,
  }) : super(const MarkdownToFlashcardState());

  Future<void> getMarkdownFile() async {
    emit(state.copyWith(status: GetMarkdownFileStatus.loading));

    try {
      Note? note = await noteRepository.getNote();

      if (note != null) {
        note = convertMarkdownToHTMLUseCase(note);
        await addQuestionAnswerPairsInNoteToAnkidroid(note);

        emit(
          state.copyWith(
            status: GetMarkdownFileStatus.success,
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
