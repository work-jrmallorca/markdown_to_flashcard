import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/add_flashcard_ids_to_note_use_case.dart';

import '../../data/repositories/note_repository.dart';
import '../../domain/entities/note.dart';
import '../../domain/use_cases/convert_markdown_to_html_use_case.dart';
import '../../domain/use_cases/create_or_update_flashcards_in_note_to_ankidroid_use_case.dart';
import 'markdown_to_flashcard_state.dart';

class MarkdownToFlashcardCubit extends Cubit<MarkdownToFlashcardState> {
  final NoteRepository noteRepository;
  final ConvertMarkdownToHTMLUseCase convertMarkdownToHTML;
  final CreateOrUpdateFlashcardsInNoteToAnkidroidUseCase
      addQuestionAnswerPairsInNoteToAnkidroidAndGetIDs;
  final AddFlashcardIDsToNoteUseCase addFlashcardIDsToNote;

  MarkdownToFlashcardCubit({
    required this.noteRepository,
    required this.convertMarkdownToHTML,
    required this.addQuestionAnswerPairsInNoteToAnkidroidAndGetIDs,
    required this.addFlashcardIDsToNote,
  }) : super(const MarkdownToFlashcardState());

  Future<void> getMarkdownFiles() async {
    emit(state.copyWith(status: GetMarkdownFilesStatus.loading));

    try {
      List<Note>? markdownNotes = await noteRepository.getNote();

      if (markdownNotes != null && markdownNotes.isNotEmpty) {
        for (var markdownNote in markdownNotes) {
          Note htmlNote = convertMarkdownToHTML(markdownNote);
          List<int> ids =
              await addQuestionAnswerPairsInNoteToAnkidroidAndGetIDs(htmlNote);
          markdownNote = addFlashcardIDsToNote(markdownNote, ids);
          noteRepository.updateNote(markdownNote);
        }

        emit(
          state.copyWith(
            status: GetMarkdownFilesStatus.success,
            notes: markdownNotes,
          ),
        );
      } else {
        emit(state.copyWith(status: GetMarkdownFilesStatus.cancelled));
      }
    } on Exception catch (exception) {
      emit(
        state.copyWith(
          status: GetMarkdownFilesStatus.failure,
          exception: exception,
        ),
      );
    }
  }
}
