import 'package:firebase_database/firebase_database.dart';
import 'package:sudoku_flutter/models/my_sudoku.dart';

class FirebaseDataSudoku {
  final ref = FirebaseDatabase.instance.ref();

  Future<String?> createSudoku(MySudoku sudoku) async {
    final String? newPostSudokuKey = await ref.child("sudokus").push().key;
    await ref
        .child("sudokus/$newPostSudokuKey")
        .set(sudoku.copyWith(sudokuId: newPostSudokuKey!).toMap());
    return newPostSudokuKey;
  }

  Future<MySudoku> getSudoku(String sudokuKey) async {
    final sudokuData = await ref.child('sudokus/$sudokuKey').get();
    if (sudokuData.exists) {
      final Map<dynamic, dynamic> sudokuValue =
          sudokuData.value as Map<dynamic, dynamic>;
      return MySudoku.fromMap(sudokuValue);
    } else {
      return MySudoku.empty;
    }
  }

  Future<void> deleteSudoku(String sudokuKey) async {
    final sudokuData = await ref.child('sudokus/$sudokuKey').get();
    if (sudokuData.exists) {
      ref.child('sudokus/$sudokuKey').remove();
      print("sudoku deleted");
    } else {
      print("sudoku not found");
    }
  }

  Future<void> updateSudoku(MySudoku sudoku) async {
    final sudokuData = await ref.child('sudokus/${sudoku.sudokuId}').get();
    if (sudokuData.exists) {
      await ref.child('sudokus/${sudoku.sudokuId}').update(sudoku.toMap());
    } else {
      print("sudoku not found");
    }
  }

  Future<void> deleteAllSudoku() async {
    final sudokuData = await ref.child('sudokus').get();
    if (sudokuData.exists) {
      ref.child('sudokus').remove();
      print("all sudoku deleted");
    } else {
      print("sudoku not found");
    }
  }

  Future<List<MySudoku>> allUserSudokus(List<String> sudokusIds) async {
    List<MySudoku> allSudokus = [];
    for (String id in sudokusIds) {
      final sudokuData = await ref.child('sudokus/$id').get();
      if (sudokuData.exists) {
        allSudokus
            .add(MySudoku.fromMap(sudokuData.value as Map<dynamic, dynamic>));
      }
    }
    return allSudokus;
  }
}
