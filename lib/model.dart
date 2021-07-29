import 'dart:math';

const complete_grid = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, -1]
];

class PuzzleModel {
  var grid = complete_grid
      .map((e) => List.from(e, growable: false))
      .toList(growable: false);
  var cursorX = 2;
  var cursorY = 2;

  bool move(x, y) {
    final distX = (cursorX - x).abs();
    final distY = (cursorY - y).abs();

    if (distX > 1 || distY > 1 || distX == distY) {
      return false;
    }

    grid[cursorY][cursorX] = grid[y][x];
    grid[y][x] = -1;
    cursorX = x;
    cursorY = y;
    return true;
  }

  bool checkCompletion() {
    for(var x = 0; x < 3; x++) {
      for(var y = 0; y < 3; y++) {
        if(this.get(x, y) != complete_grid[y][x]) {
          return false;
        }
      }
    }

    return true;
  }

  int get(int x, int y) {
    return grid[y][x];
  }

  void shuffle() {
    final random = new Random();

    for (int i = 0; i < 1000; i++) {
      int r = random.nextInt(4);
      int x = 0, y = 0;

      switch (r) {
        case 0:
          x = 1;
          break;
        case 1:
          y = 1;
          break;
        case 2:
          x = -1;
          break;
        case 3:
          y = -1;
          break;
      }

      x += cursorX;
      y += cursorY;

      if(x < 0 || x >= 3 || y < 0 || y >= 3) {
        continue;
      }

      this.move(x, y);
    }
  }
}
