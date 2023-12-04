import 'package:equatable/equatable.dart';

import '../../domain/entities/note.dart';

enum GetMarkdownFilesStatus {
  initial,
  loading,
  success,
  failure,
  cancelled,
}

class MarkdownToFlashcardState extends Equatable {
  final GetMarkdownFilesStatus status;
  final List<Note> notes;
  final String? errorMessage;

  const MarkdownToFlashcardState({
    this.status = GetMarkdownFilesStatus.initial,
    this.notes = const [],
    this.errorMessage,
  });

  MarkdownToFlashcardState copyWith({
    GetMarkdownFilesStatus? status,
    List<Note>? notes,
    String? errorMessage,
  }) {
    return MarkdownToFlashcardState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notes, errorMessage];
}
