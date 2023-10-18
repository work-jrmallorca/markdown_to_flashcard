import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

class TutorialScreen extends StatelessWidget {
  final String tagsSnippet = '''
```
---
tags: [tag1, tag 2, ..., tag-n]
```
  ''';

  final String deckSnippet = '''
```
deck: Zettelkasten
---
```
  ''';

  final String bodySnippet = '''
```
# Title

This is the body.
Put **anything** in here!
```
  ''';

  final String questionAnswerSnippet = '''
```
Question 1 :: Answer 1

Question 2 :: Answer 2
```
  ''';

  final String tagsDescription = '''
These tags are used to tag the note in Anki.

Tags must be comma-separated, or they will not be properly formatted.

Tags do not need to be hidden within the YAML metadata, but they must be present in the file.
  ''';

  final String deckDescription = '''
The deck name specifies which deck the flashcards will be inserted in Anki.

The deck name does not need to be hidden within the YAML metadata, but it must be present in the file.
  ''';

  final String bodyDescription = '''
This is the body of the Markdown file.
  ''';

  final String questionAnswerDescription = '''
Each question and answer pair is a flashcard that will be imported into anki.

Every question and answer must be separated by a double colon (::).

The question and answer pairs do not need to be at the end of the file.
  ''';

  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        onPressed: () => context.go('/'),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          25.0, 50.0, 25.0, kBottomNavigationBarHeight + 25.0),
      children: [
        _buildTitle(),
        const SizedBox(height: 20.0),
        const Divider(),
        const SizedBox(height: 20.0),
        _buildDescription(),
        const SizedBox(height: 10.0),
        _buildFileSnippet(
          context,
          exampleSnippet: tagsSnippet,
          description: tagsDescription,
        ),
        _buildFileSnippet(
          context,
          exampleSnippet: deckSnippet,
          description: deckDescription,
        ),
        _buildFileSnippet(
          context,
          exampleSnippet: bodySnippet,
          description: bodyDescription,
        ),
        _buildFileSnippet(
          context,
          exampleSnippet: questionAnswerSnippet,
          description: questionAnswerDescription,
        ),
      ],
    );
  }

  Text _buildDescription() {
    return const Text(
      '''
The following snippet below is an example of a correctly formatted Markdown (.md) or text (.txt) file.

Select the question mark icon for more information on each section.
      ''',
      style: TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'How to correctly format files for import',
      style: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildFileSnippet(
    BuildContext context, {
    required String exampleSnippet,
    required String description,
  }) {
    return ListTile(
      title: MarkdownBody(
        data: exampleSnippet,
      ),
      trailing: ElTooltip(
        showChildAboveOverlay: false,
        color: Theme.of(context).secondaryHeaderColor,
        position: ElTooltipPosition.leftCenter,
        content: Text(description),
        child: const Icon(Icons.question_mark_rounded),
      ),
    );
  }
}
