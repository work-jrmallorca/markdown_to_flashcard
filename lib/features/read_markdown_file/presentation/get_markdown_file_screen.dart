import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_to_flashcard/features/theme/presentation/widgets/cycle_theme_button.dart';

import 'bloc/markdown_to_flashcard_cubit.dart';
import 'bloc/markdown_to_flashcard_state.dart';

class GetMarkdownFileScreen extends StatelessWidget {
  const GetMarkdownFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: FloatingActionButton.extended(
          label: const Text('Select a Markdown File'),
          onPressed: () =>
              context.read<MarkdownToFlashcardCubit>().getMarkdownFiles(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(side: BorderSide()),
        ),
        notchMargin: 8.0,
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.question_mark_rounded),
              onPressed: () => context.go('/tutorial'),
            ),
            const Spacer(),
            const CycleThemeButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<MarkdownToFlashcardCubit, MarkdownToFlashcardState>(
      listener: (context, state) {
        switch (state.status) {
          case GetMarkdownFilesStatus.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${state.exception}')),
            );
            break;
          case GetMarkdownFilesStatus.cancelled:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File selection cancelled')),
            );
            break;
          default:
        }
      },
      builder: (context, state) {
        return state.status == GetMarkdownFilesStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
      case GetMarkdownFilesStatus.success:
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
            color: Colors.black54,
            child: Image.asset(
              'assets/images/anki.png',
              scale: 5.0,
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
      case GetMarkdownFilesStatus.loading:
        title = '';
        description = '';
      case GetMarkdownFilesStatus.success:
        title = 'Success!';
        description = 'Successfully imported the following notes. Import more?';
      default:
        title = 'Import to Anki';
        description =
            'Select a markdown or text file to import your flashcards from.';
    }

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 25.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 25.0),
              if (state.notes.isNotEmpty)
                Markdown(
                  softLineBreak: true,
                  data: '''
```
                ${state.notes.map((note) => note.title).join(',\n')}
                ```
                            ''',
                ),
            ],
          ),
        ),
      ],
    );
  }
}
