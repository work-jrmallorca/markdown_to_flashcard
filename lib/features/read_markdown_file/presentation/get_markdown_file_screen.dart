import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'bloc/markdown_to_flashcard_cubit.dart';
import 'bloc/markdown_to_flashcard_state.dart';

class GetMarkdownFileScreen extends StatelessWidget {
  const GetMarkdownFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Select a Markdown File'),
        onPressed: () =>
            context.read<MarkdownToFlashcardCubit>().getMarkdownFile(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      listener: (context, state) {
        switch (state.status) {
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
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(child: _buildImage(context, state)),
            Expanded(child: _buildDescription(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildImage(BuildContext context, MarkdownToFlashcardState state) {
    switch (state.status) {
      case GetMarkdownFileStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case GetMarkdownFileStatus.success:
        return const Center(
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 200.0,
            color: Colors.green,
          ),
        );
      default:
        return Center(
          child: DropShadow(
            offset: const Offset(8.0, 8.0),
            child: Shimmer(
              child: Image.asset(
                'assets/images/anki.png',
                scale: 5.0,
              ),
            ),
          ),
        );
    }
  }

  Widget _buildDescription(
      BuildContext context, MarkdownToFlashcardState state) {
    String title;
    String description;

    switch (state.status) {
      case GetMarkdownFileStatus.loading:
        title = '';
        description = '';
      case GetMarkdownFileStatus.success:
        title = 'Success!';
        description =
            'Successfully imported from file ${state.note!.fileName}. Import from another file?';
      default:
        title = 'Import to Anki';
        description = 'Select a markdown file to import your flashcards from.';
    }

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 36.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 25.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }
}
