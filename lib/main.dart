import 'dart:async';

import 'package:flutter/material.dart';
import 'package:slide_puzzle/model.dart';

import 'grid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slide Puzzle',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(50, 50, 50, 1),
          accentColor: Colors.white),
      home: Game(),
    );
  }
}

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final _puzzle = new PuzzleModel();
  var _moves = 0;
  var _completed = false;
  var _seconds = 0;
  Timer? _timer;

  void _tick() {
    setState(() {
      _seconds++;
    });
  }

  @override
  void initState() {
    super.initState();
    this._puzzle.shuffle();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _win() {
    _completed = true;
    _stop();
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text("You win!")));
  }

  void _onClick(int x, int y) {
    if (_completed) {
      return;
    }

    if (_timer == null) {
      _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        _tick();
      });
    }

    setState(() {
      final success = _puzzle.move(x, y);
      if (success) {
        _moves++;
        if (_puzzle.checkCompletion()) {
          _win();
        }
      }
    });
  }

  void _onShuffle() {
    setState(() {
      _puzzle.shuffle();
      _moves = 0;
      _stop();
      _seconds = 0;
      _completed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Slide Puzzle"),
        ),
        body: Column(
          children: [
            Expanded(child: GameGrid(puzzle: _puzzle, onClick: _onClick)),
            Row(children: [
              ElevatedButton(
                  onPressed: () {
                    _onShuffle();
                  },
                  style: ElevatedButton.styleFrom(primary: theme.primaryColor),
                  child: Icon(Icons.refresh)),
              Text("Time: " + _seconds.toString()),
              Text("Moves: " + _moves.toString())
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
          ],
        ));
  }
}
