import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_flutter/data_to_screen/sudoku_infos.dart';
import 'package:sudoku_flutter/widgets/button_text_ui.dart';

class SudokuNumPad extends StatefulWidget {
  const SudokuNumPad({super.key});

  @override
  State<SudokuNumPad> createState() => _SudokuNumPadState();
}

class _SudokuNumPadState extends State<SudokuNumPad> {
  bool isOnNotes = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30 - kToolbarHeight,
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Colors.black, width: 3.5)),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<SudokuInfos>(builder: (context, sudoku, child) {
                  return ButtonTextUI.whiteBorder(
                    onPressed: () {
                      setState(() {
                        isOnNotes = !isOnNotes;
                      });
                    },
                    text: "Notes",
                    color: isOnNotes
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.background,
                    textColor: isOnNotes
                        ? Colors.white
                        : Theme.of(context).colorScheme.surface,
                    border: true,
                  );
                }),
                Consumer<SudokuInfos>(builder: (context, sudoku, child) {
                  return ButtonTextUI.whiteBorder(
                      onPressed: () {
                        if (sudoku.isSelectedSquare() &&
                            sudoku.getSudoku().sudoku[sudoku.selectedSquare] !=
                                -1) {
                          List<int> updatedSudoku = sudoku.sudoku.sudoku
                              .toList()
                            ..[sudoku.selectedSquare] = -1;
                          sudoku.updateSudoku(
                              sudoku.sudoku.copyWith(sudoku: updatedSudoku));
                        } else {
                          null;
                        }
                      },
                      text: "Vider");
                }),
                ButtonTextUI.whiteBorder(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    text: "Stopper"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: isOnNotes ? notesPadFunc() : sudokuNumPadFunc(),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> sudokuNumPadFunc() {
  List<int> numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  return numberList.map((number) {
    return Consumer<SudokuInfos>(builder: (context, sudoku, child) {
      return GestureDetector(
        onTap: () {
          List<int> updatedSudoku = sudoku.sudoku.sudoku.toList()
            ..[sudoku.selectedSquare] = number;
          sudoku.updateSudoku(sudoku.sudoku.copyWith(sudoku: updatedSudoku));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.width * 0.1,
          color: Colors.transparent,
          child: Center(
            child: Text(number.toString(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: sudoku.getSelectedSquare() != -1
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.4),
                    )),
          ),
        ),
      );
    });
  }).toList();
}

List<Widget> notesPadFunc() {
  List<int> numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  return numberList.map((number) {
    return Consumer<SudokuInfos>(builder: (context, sudoku, child) {
      return GestureDetector(
        onTap: () {
          if (sudoku.isSelectedSquare()) {
            List<List<bool>> updateNotes = sudoku.sudoku.notes;
            updateNotes[sudoku.selectedSquare][number - 1] =
                !updateNotes[sudoku.selectedSquare][number - 1];
            sudoku.updateSudoku(sudoku.sudoku.copyWith(notes: updateNotes));
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.width * 0.1,
          color: Colors.transparent,
          child: Center(
            child: Text(number.toString(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: sudoku.isSelectedSquare() &&
                              sudoku.sudoku.notes[sudoku.selectedSquare]
                                  [number - 1]
                          ? Theme.of(context).colorScheme.onPrimary
                          : Colors.black,
                    )),
          ),
        ),
      );
    });
  }).toList();
}
