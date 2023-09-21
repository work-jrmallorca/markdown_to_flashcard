import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/markdown_to_flashcard_cubit.dart';
import 'bloc/markdown_to_flashcard_state.dart';

class GetMarkdownFileScreen extends StatelessWidget {
  const GetMarkdownFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: buildBody(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Select a Markdown File'),
        onPressed: () =>
            context.read<MarkdownToFlashcardCubit>().getMarkdownFile(),
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
        return Column(
          children: [
            Expanded(child: _buildImage(context, state)),
            Expanded(child: _buildDescription()),
          ],
        );
      },
    );
  }

  Widget _buildImage(BuildContext context, MarkdownToFlashcardState state) {
    switch (state.status) {
      case GetMarkdownFileStatus.initial:
        return Center(
          child: DropShadow(
            offset: const Offset(8.0, 8.0),
            child: Image.asset(
              'assets/images/anki.png',
              scale: 5.0,
            ),
          ),
        );
      case GetMarkdownFileStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Container();
    }
  }

  Widget _buildDescription() {
    return const Column(
      children: [
        Text(
          'Import to Anki',
          style: TextStyle(
            color: Colors.black,
            fontSize: 36.0,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
        ),
        SizedBox(height: 25.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            'Select a markdown file to import your flashcards from.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
