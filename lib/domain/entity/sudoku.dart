class SudokuEntity {
  List<List<int>> sudoku;
  List<List<int>> solution;
  String difficulty;

  SudokuEntity({
    required this.sudoku,
    required this.solution,
    required this.difficulty,
  });
}
