import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_flutter/data_to_screen/auth.dart';
import 'package:sudoku_flutter/data_to_screen/sudoku_infos.dart';
import 'package:sudoku_flutter/widgets/loading_widget.dart';
import 'package:sudoku_flutter/widgets/modal_ui.dart';
import 'package:sudoku_flutter/widgets/sudoku_screen/sudoku_grid.dart';
import 'package:sudoku_flutter/widgets/sudoku_screen/sudoku_num_pad.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key, required this.sudokuId});

  final String? sudokuId;

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  final Map<String, bool> loading = {"sudokuGrid": false};
  bool isModalClosed = false;

  void loadingCallback(String whichLoad, bool value, BuildContext context) {
    loading[whichLoad] = value;

    List<bool> listCompare = [];

    for (value in loading.values) {
      listCompare.add(value);
    }

    if (listEquals(loading.values.toList(), listCompare)) {
      Provider.of<IsLoading>(context, listen: false).setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SudokuInfos(),
        builder: (context, child) {
          // Provider.of<IsLoading>(context, listen: false).setLoading(false);
          Provider.of<SudokuInfos>(context, listen: false)
              .setSudoku(widget.sudokuId);
          Provider.of<Auth>(context, listen: false)
              .chgeLastSudoku(widget.sudokuId!);
          return Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SudokuGrid(loadingCallback: loadingCallback),
                const SudokuNumPad(),
              ],
            ),
            Consumer<SudokuInfos>(builder: (context, sudoku, child) {
              if (sudoku.getSudoku().isCompleted && !isModalClosed) {
                return ModalUI(
                    textModal: "Sudoku Complété !!!",
                    buttonText: "Nouveau Sudoku",
                    closeFunction: () {
                      setState(() {
                        isModalClosed = true;
                      });
                    },
                    bottomButonFunction: () {
                      context.go("/create_sudoku");
                    });
              } else {
                return const SizedBox();
              }
            })
          ]);
        });
  }
}
