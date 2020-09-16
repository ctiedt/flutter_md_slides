import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_md_slides/slide.dart';

class SlideShow extends StatefulWidget {
  final List<String> slides;
  final MarkdownStyleSheet theme;
  final bool isEmbedded;

  const SlideShow({Key key, this.slides, this.theme, this.isEmbedded = false})
      : super(key: key);

  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  PageController _pageController;
  FocusNode _node;
  int _currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    _node = FocusNode();
    _node.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: widget.slides
              .map((e) => Align(
                    alignment: Alignment.topCenter,
                    child: Slide(
                      content: e,
                      theme: widget.theme,
                    ),
                  ))
              .toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: _buildNavigationControls(context),
          ),
        )
      ],
    );
  }

  Widget _buildNavigationControls(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _node,
      onKey: (key) {
        if (key.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          _previousSlide();
        } else if (key.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          _nextSlide();
        }
      },
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (widget.isEmbedded)
          IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        Spacer(),
        IconButton(icon: Icon(Icons.arrow_back), onPressed: _previousSlide),
        Chip(label: Text('${_currentIndex + 1}/${widget.slides.length}')),
        IconButton(icon: Icon(Icons.arrow_forward), onPressed: _nextSlide),
      ]),
    );
  }

  void _previousSlide() {
    setState(() {
      _pageController.previousPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _nextSlide() {
    setState(() {
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}
