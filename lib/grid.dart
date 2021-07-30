import 'package:flutter/material.dart';
import 'model.dart';

const MARGIN = 1.5;

class GameTile extends StatelessWidget {
  final String text;
  final double x, y, width, height;
  final Function onClick;

  const GameTile(
      {Key? key,
      required this.text,
      required this.onClick,
      required this.x,
      required this.y,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedPositioned(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        top: y,
        left: x,
        child: GestureDetector(
            onTap: () {
              onClick();
            },
            child: Container(
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: width,
                height: height,
                child: Center(
                    child: Text(text,
                        style: TextStyle(
                            color: theme.accentColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold))))));
  }
}

class GameGrid extends StatelessWidget {
  final PuzzleModel puzzle;
  final Function onClick;

  const GameGrid({Key? key, required this.puzzle, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(MARGIN),
        child: LayoutBuilder(builder: (context, constraints) {
      final tiles = List<Widget>.empty(growable: true);
      for (var x = 0; x < 3; x++) {
        for (var y = 0; y < 3; y++) {
          final num = puzzle.get(x, y);
          if (num < 1) {
            continue;
          }

          final width = (constraints.maxWidth-2*MARGIN) / 3;
          final height = (constraints.maxHeight-2*MARGIN) / 3;

          final text = num.toString();
          final widget = GameTile(
              key: Key(text),
              text: text,
              onClick: () {
                onClick(x, y);
              },
              x: (width+MARGIN) * x,
              y: (height+MARGIN) * y,
              width: width,
              height: height);
          tiles.add(widget);
        }
      }

      return Stack(children: tiles);
    }));
  }
}
