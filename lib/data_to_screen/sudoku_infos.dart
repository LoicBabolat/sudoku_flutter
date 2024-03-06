import 'package:flutter/foundation.dart';
import 'package:sudoku_flutter/data/database/sudoku/entities/firebase_data_sudoku.dart';
import 'package:sudoku_flutter/data/database/user/firebase_data_user.dart';
import 'package:sudoku_flutter/models/my_sudoku.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class SudokuInfos extends ChangeNotifier {
  final FirebaseDataSudoku _fireBaseDataSudoku;
  MySudoku sudoku = MySudoku.empty;
  int selectedSquare = -1;
  int selectedRow = -1;
  int selectedColumn = -1;

  SudokuInfos(
      {FirebaseDataSudoku? fireBaseDataSudoku,
      FirebaseDataUser? fireBaseDataUser})
      : _fireBaseDataSudoku = fireBaseDataSudoku ?? FirebaseDataSudoku();

  static Future<String> createSudoku(String difficulty, String userId,
      bool isErrorIndication, bool isVisualHelp) async {
    final FirebaseDataSudoku firebaseSudoku = FirebaseDataSudoku();
    final FirebaseDataUser firebaseUser = FirebaseDataUser();
    final Map<String, dynamic> sudokuParams = generateSudokuParams(difficulty);
    String? sudokuId = await firebaseSudoku.createSudoku(MySudoku(
      sudokuId: "",
      sudoku: sudokuParams["sudoku"],
      initSudoku: sudokuParams["initSudoku"],
      solution: sudokuParams["solution"],
      userId: userId,
      time: null,
      difficulty: difficulty,
      isCompleted: false,
      notes: List<List<bool>>.from(
          sudokuParams["sudoku"].map((e) => List.generate(9, (_) => false))),
      isErrorIndication: isErrorIndication,
      isVisualHelp: isVisualHelp,
    ));

    if (sudokuId != null) {
      await firebaseUser.addUserSudoku(userId, sudokuId);
    }
    return sudokuId!;
  }

  Future<void> setSudoku(String? sudokuId) async {
    MySudoku newSudoku = await _fireBaseDataSudoku.getSudoku(sudokuId!);
    if (newSudoku.isNotEmpty) {
      sudoku = newSudoku;
    } else {
      MySudoku.empty;
    }
    notifyListeners();
  }

  MySudoku getSudoku() {
    return sudoku;
  }

  void setSelectedSquare(int square, int row, int column) {
    if (sudoku.initSudoku[square] == -1 && square != selectedSquare) {
      selectedSquare = square;
      selectedRow = row;
      selectedColumn = column;
      notifyListeners();
    } else if (selectedSquare == square) {
      selectedSquare = -1;
      selectedRow = -1;
      selectedColumn = -1;
      notifyListeners();
    }
  }

  int getSelectedSquare() {
    return selectedSquare;
  }

  bool isSelectedSquare() {
    return selectedSquare != -1;
  }

  void clearSelectedSquare() {
    selectedSquare = -1;
    notifyListeners();
  }

  Future<void> updateSudoku(MySudoku sudoku) async {
    await _fireBaseDataSudoku.updateSudoku(sudoku);
    await setSudoku(sudoku.sudokuId);
    if (await isCompletedSudoku()) {
      debugPrint("Sudoku is completed : ${sudoku.solution}");
    }
    debugPrint("${sudoku.solution}");
    notifyListeners();
  }

  Future<bool> isCompletedSudoku() async {
    if (listEquals(sudoku.sudoku, sudoku.solution)) {
      sudoku = sudoku.copyWith(isCompleted: true, initSudoku: sudoku.solution);
      selectedSquare = -1;
      await _fireBaseDataSudoku.updateSudoku(sudoku);
      return sudoku.isCompleted;
    } else {
      return sudoku.isCompleted;
    }
  }

  Future<void> updateTimeSudoku() async {}

  Future<void> updateSudokuNotes() async {}

  static Future<void> deleteAllSudoku() async {
    final FirebaseDataSudoku firebaseSudoku = FirebaseDataSudoku();
    await firebaseSudoku.deleteAllSudoku();
  }

  static Map<String, dynamic> generateSudokuParams(String difficulty) {
    Sudoku sudoku;
    switch (difficulty) {
      case "Easy":
        sudoku = Sudoku.generate(Level.easy);
        break;
      case "Medium":
        sudoku = Sudoku.generate(Level.medium);
        break;
      case "Difficile":
        sudoku = Sudoku.generate(Level.hard);
        break;
      case "Expert":
        sudoku = Sudoku.generate(Level.expert);
        break;
      default:
        sudoku = Sudoku.generate(Level.easy);
    }
    return {
      "sudoku": sudoku.puzzle,
      "initSudoku": sudoku.puzzle,
      "solution": sudoku.solution,
    };
  }
}
