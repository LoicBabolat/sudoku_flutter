import 'package:equatable/equatable.dart';

class MySudoku extends Equatable {
  const MySudoku(
      {required this.sudokuId,
      required this.sudoku,
      required this.initSudoku,
      required this.solution,
      required this.userId,
      required this.time,
      required this.difficulty,
      required this.isCompleted,
      required this.notes,
      required this.isErrorIndication,
      required this.isVisualHelp});

  final String sudokuId;
  final List<int> sudoku;
  final List<int> initSudoku;
  final List<int> solution;
  final String userId;
  final DateTime? time;
  final String difficulty;
  final bool isCompleted;
  final List<List<bool>> notes;
  final bool isErrorIndication;
  final bool isVisualHelp;

  static const empty = MySudoku(
    sudokuId: '',
    sudoku: [],
    initSudoku: [],
    solution: [],
    difficulty: '',
    userId: '',
    time: null,
    isCompleted: false,
    notes: [],
    isErrorIndication: false,
    isVisualHelp: true,
  );

  Map<String, dynamic> toMap() {
    return {
      'sudokuId': sudokuId,
      'sudoku': sudoku,
      'initSudoku': initSudoku,
      'solution': solution,
      'userId': userId,
      'time': time,
      'difficulty': difficulty,
      'isCompleted': isCompleted,
      'notes': notes,
      'isErrorIndication': isErrorIndication,
      'isVisualHelp': isVisualHelp,
    };
  }

  factory MySudoku.fromMap(Map<dynamic, dynamic> map) {
    return MySudoku(
      sudokuId: map['sudokuId'],
      sudoku: List<int>.from(map['sudoku']),
      initSudoku: List<int>.from(map['initSudoku']),
      solution: List<int>.from(map['solution']),
      userId: map['userId'],
      time: map['time'],
      difficulty: map['difficulty'],
      isCompleted: map['isCompleted'],
      notes: List<List<bool>>.from(map["notes"].map((e) => List<bool>.from(e))),
      isErrorIndication: map['isErrorIndication'],
      isVisualHelp: map['isVisualHelp'],
    );
  }

  MySudoku copyWith({
    final String? sudokuId,
    final List<int>? sudoku,
    final List<int>? initSudoku,
    final List<int>? solution,
    final String? userId,
    final DateTime? time,
    final String? difficulty,
    final bool? isCompleted,
    final List<List<bool>>? notes,
    final bool? isErrorIndication,
    final bool? isVisualHelp,
  }) {
    return MySudoku(
      sudokuId: sudokuId ?? this.sudokuId,
      sudoku: sudoku ?? this.sudoku,
      initSudoku: initSudoku ?? this.initSudoku,
      solution: solution ?? this.solution,
      difficulty: difficulty ?? this.difficulty,
      userId: userId ?? this.userId,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      isErrorIndication: isErrorIndication ?? this.isErrorIndication,
      isVisualHelp: isVisualHelp ?? this.isVisualHelp,
    );
  }

  bool get isEmpty => this == MySudoku.empty;

  bool get isNotEmpty => this != MySudoku.empty;

  @override
  List<Object?> get props {
    return [
      sudokuId,
      sudoku,
      initSudoku,
      solution,
      userId,
      time,
      difficulty,
      isCompleted,
      notes,
      isErrorIndication,
      isVisualHelp,
    ];
  }
}
