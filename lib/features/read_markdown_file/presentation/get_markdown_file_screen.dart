import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/markdown_to_flashcard_cubit.dart';
import 'bloc/markdown_to_flashcard_state.dart';

class GetMarkdownFileScreen extends StatelessWidget {
  const GetMarkdownFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markdown to Flashcards'),
      ),
      body: buildBody(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.read<MarkdownToFlashcardCubit>().getMarkdownFile(),
        label: const Text('Select a Markdown file'),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      listener: (context, state) {
        switch (state.status) {
          case GetMarkdownFileStatus.success:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File loaded: ${state.note?.fileName}')),
            );
            break;
          case GetMarkdownFileStatus.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${state.exception}')),
            );
            break;
          case GetMarkdownFileStatus.cancelled:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File selection cancelled')),
            );
            break;
          default:
        }
        if (state.status == GetMarkdownFileStatus.loading) {
        } else if (state.status == GetMarkdownFileStatus.loading) {}
      },
      builder: (context, state) {
        switch (state.status) {
          case GetMarkdownFileStatus.loading:
            return const Center(child: CircularProgressIndicator());
          default:
            return Container();
        }
      },
    );
  }
}
