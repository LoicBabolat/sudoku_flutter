import 'package:equatable/equatable.dart';
import 'package:sudoku_flutter/models/my_sudoku.dart';

class AllMyUserSudokus extends Equatable {
  const AllMyUserSudokus({required this.allUserSudokus});

  final List<MySudoku> allUserSudokus;

  @override
  List<Object?> get props => [allUserSudokus];
}
