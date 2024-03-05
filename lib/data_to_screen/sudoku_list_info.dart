import 'package:flutter/foundation.dart';
import 'package:sudoku_flutter/models/my_sudoku.dart';

class SudokuListInfo extends ChangeNotifier {
  List<MySudoku> sudokus = [MySudoku.empty];
}
