import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_flutter/data_to_screen/sudoku_infos.dart';
import 'package:sudoku_flutter/models/my_sudoku.dart';
import 'package:sudoku_flutter/widgets/button_text_ui.dart';

class SudokuGrid extends StatelessWidget {
  const SudokuGrid({super.key, required this.loadingCallback});

  final void Function(String whichLoad, bool value, BuildContext ctx)
      loadingCallback;

  @override
  Widget build(BuildContext context) {
    return Consumer<SudokuInfos>(builder: (context, sudokuInfos, child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.70 - kToolbarHeight,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonTextUI.whiteBorder(
                    onPressed: () {
                      sudokuInfos.updateSudoku(sudokuInfos.sudoku.copyWith(
                          isVisualHelp: !sudokuInfos.sudoku.isVisualHelp));
                    },
                    text: "Aide",
                    textColor: sudokuInfos.sudoku.isVisualHelp
                        ? Colors.white
                        : Colors.black,
                    color: sudokuInfos.sudoku.isVisualHelp
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.background,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                  ),
                  ButtonTextUI.whiteBorder(
                    onPressed: () {
                      sudokuInfos.updateSudoku(sudokuInfos.sudoku.copyWith(
                          isErrorIndication:
                              !sudokuInfos.sudoku.isErrorIndication));
                    },
                    text: "Indication",
                    textColor: sudokuInfos.sudoku.isErrorIndication
                        ? Colors.white
                        : Colors.black,
                    color: sudokuInfos.sudoku.isErrorIndication
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.background,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                  ),
                ],
              ),
              ...sudokuGridFunc(
                sudokuInfos,
                context,
                loadingCallback,
              )
            ]),
      );
    });
  }

  List<Widget> sudokuGridFunc(
      SudokuInfos sudoku,
      context,
      void Function(String whichLoad, bool value, BuildContext ctx)
          loadingCallback) {
    List<int> rows = [0, 1, 2, 3, 4, 5, 6, 7, 8];
    if (sudoku.getSudoku().isEmpty) {
      return [const CircularProgressIndicator()];
    } else {
      return rows.map((int e) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: RowSudokuFunc(
                context,
                e,
                sudoku.getSudoku(),
                sudoku.setSelectedSquare,
                sudoku.getSelectedSquare(),
                sudoku.selectedRow,
                sudoku.selectedColumn));
      }).toList();
    }
  }

  List<Widget> RowSudokuFunc(
      context,
      int row,
      MySudoku sudokuInstance,
      final void Function(int square, int row, int column)
          setSelectedSquareInstance,
      int getSelectedSquareInstance,
      int selectedRow,
      int selectedColumn) {
    List<int> cols = [0, 1, 2, 3, 4, 5, 6, 7, 8];
    return cols.map((int e) {
      int index = e + 9 * row;
      return Expanded(
          child: GestureDetector(
        onTap: () {
          setSelectedSquareInstance(index, row, e);
        },
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: sudokuInstance.isErrorIndication
                  ? isErrorOn(sudokuInstance, getSelectedSquareInstance, index,
                      context, row, e, selectedRow, selectedColumn)
                  : isErrorOff(sudokuInstance, getSelectedSquareInstance, index,
                      context, row, e, selectedRow, selectedColumn),
              border: Border(
                  top: const BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(
                      color: Colors.black, width: row == 2 || row == 5 ? 3 : 1),
                  left: const BorderSide(color: Colors.black, width: 1),
                  right: BorderSide(
                      color: Colors.black, width: e == 2 || e == 5 ? 3 : 1)),
            ),
            child: Center(
              child: sudokuInstance.sudoku[index] != -1
                  ? InputNumber(index: index, sudokuInstance: sudokuInstance)
                  : NotesNumbers(index: index, sudokuInstance: sudokuInstance),
            ),
          ),
        ),
      ));
    }).toList();
  }
}

Color isErrorOn(
    MySudoku sudokuInstance,
    int getSelectedSquareInstance,
    int index,
    context,
    int row,
    int column,
    int selectedRow,
    int selectedColumn) {
  if (getSelectedSquareInstance == index &&
      sudokuInstance.sudoku[index] == sudokuInstance.solution[index]) {
    return Color.fromARGB(255, 99, 190, 102);
  } else if (getSelectedSquareInstance == index &&
      sudokuInstance.sudoku[index] != sudokuInstance.solution[index] &&
      sudokuInstance.sudoku[index] != -1) {
    return Theme.of(context).colorScheme.error;
  } else if (getSelectedSquareInstance == index) {
    return Theme.of(context).colorScheme.secondary;
  } else {
    if (sudokuInstance.isVisualHelp) {
      if (row == selectedRow ||
          column == selectedColumn ||
          ((selectedRow + 1) - selectedRow % 3 == (row + 1) - row % 3 &&
              (selectedColumn + 1) - selectedColumn % 3 ==
                  (column + 1) - column % 3)) {
        return Theme.of(context).colorScheme.tertiary;
      } else {
        return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }
}

Color isErrorOff(
    MySudoku sudokuInstance,
    int getSelectedSquareInstance,
    int index,
    context,
    int row,
    int column,
    int selectedRow,
    int selectedColumn) {
  if (getSelectedSquareInstance == index) {
    return Theme.of(context).colorScheme.secondary;
  } else {
    if (sudokuInstance.isVisualHelp) {
      if (row == selectedRow ||
          column == selectedColumn ||
          ((selectedRow + 1) - selectedRow % 3 == (row + 1) - row % 3 &&
              (selectedColumn + 1) - selectedColumn % 3 ==
                  (column + 1) - column % 3)) {
        return Theme.of(context).colorScheme.tertiary;
      } else {
        return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }
}

// Color isVisualHelpoOn(
//     MySudoku sudokuInstance,
//     int getSelectedSquareInstance,
//     int index,
//     context,
//     int row,
//     int column,
//     int selectedRow,
//     int selectedColumn) {
//   if (row == selectedRow ||
//       column == selectedColumn ||
//       ((selectedRow + 1) - selectedRow % 3 == (row + 1) - row % 3 &&
//           (selectedColumn + 1) - selectedColumn % 3 ==
//               (column + 1) - column % 3)) {
//     return Theme.of(context).colorScheme.tertiary;
//   } else {
//     return Colors.transparent;
//   }
// }

class InputNumber extends StatelessWidget {
  const InputNumber({
    super.key,
    required this.index,
    required this.sudokuInstance,
  });

  final int index;
  final MySudoku sudokuInstance;

  @override
  Widget build(BuildContext context) {
    return Text(
      sudokuInstance.sudoku[index].toString() == "-1"
          ? ""
          : sudokuInstance.sudoku[index].toString(),
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color:
              sudokuInstance.sudoku[index] == sudokuInstance.initSudoku[index]
                  ? Colors.black
                  : const Color.fromARGB(255, 48, 56, 232),
          fontSize: 23.0),
    );
  }
}

class NotesNumbers extends StatelessWidget {
  const NotesNumbers({
    super.key,
    required this.index,
    required this.sudokuInstance,
  });

  final int index;
  final MySudoku sudokuInstance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: notesNumbersFunc([
              1,
              2,
              3
            ], [
              sudokuInstance.notes[index][0],
              sudokuInstance.notes[index][1],
              sudokuInstance.notes[index][2]
            ]),
          ),
        ),
        Expanded(
          child: Row(
            children: notesNumbersFunc([
              4,
              5,
              6
            ], [
              sudokuInstance.notes[index][3],
              sudokuInstance.notes[index][4],
              sudokuInstance.notes[index][5]
            ]),
          ),
        ),
        Expanded(
          child: Row(
              children: notesNumbersFunc([
            7,
            8,
            9
          ], [
            sudokuInstance.notes[index][6],
            sudokuInstance.notes[index][7],
            sudokuInstance.notes[index][8]
          ])),
        ),
        const SizedBox(height: 2.0)
      ],
    );
  }

  List<Widget> notesNumbersFunc(List<int> listNumbers, List<bool> isNoted) {
    int indexFunc = -1;
    return listNumbers.map((number) {
      indexFunc++;
      return Expanded(
        child: SizedBox(
          child: Text(isNoted[indexFunc] ? number.toString() : "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11,
              )),
        ),
      );
    }).toList();
  }
}
