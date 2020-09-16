import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Slide extends StatelessWidget {
  final String content;
  final MarkdownStyleSheet theme;

  const Slide({Key key, this.content, this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 512,
      child: MarkdownBody(
        data: content,
        styleSheet: theme ?? MarkdownStyleSheet.fromTheme(Theme.of(context)),
      ),
    );
  }
}
