import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_flutter/data_to_screen/auth.dart';
import 'package:sudoku_flutter/models/my_sudoku.dart';
import 'package:sudoku_flutter/widgets/modal_ui.dart';

class SudokusListScreen extends StatefulWidget {
  const SudokusListScreen({super.key, required this.isFinished});

  final bool isFinished;

  @override
  State<SudokusListScreen> createState() => _SudokusListScreenState();
}

class _SudokusListScreenState extends State<SudokusListScreen> {
  List<MySudoku>? userSudokus;
  bool isModal = false;
  MySudoku selectedSudoku = MySudoku.empty;

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return Stack(children: [
        if (auth.userSudokus != null) ...[
          ListSudokus(
              isFinished: widget.isFinished,
              listSudokus: auth.userSudokus!
                  .where((element) => element.isCompleted == widget.isFinished)
                  .toList(),
              callBack: (MySudoku sudoku) {
                setState(() {
                  isModal = true;
                  selectedSudoku = sudoku;
                });
              }),
        ] else ...[
          const Center(child: CircularProgressIndicator()),
        ],
        if (isModal && selectedSudoku.isNotEmpty) ...[
          ModalUI(
              textModal:
                  "${widget.isFinished ? "Sudoku fini \n" : ""} Cases remplies : ${fillSquare(selectedSudoku.sudoku)} / 81 \n Difficulté : ${selectedSudoku.difficulty}",
              closeFunction: () {
                setState(() {
                  isModal = false;
                });
              },
              bottomButonFunction: () {
                setState(() {
                  isModal = false;
                });
                context.go(
                    "/sudoku_list/${widget.isFinished}/sudoku/${selectedSudoku.sudokuId}");
              },
              buttonText: "Lancer le sudoku"),
        ]
      ]);
    });
  }
}

class ListSudokus extends StatelessWidget {
  const ListSudokus(
      {super.key,
      required this.listSudokus,
      required this.callBack,
      required this.isFinished});

  final List<MySudoku> listSudokus;
  final Function(MySudoku sudoku) callBack;
  final bool isFinished;

  @override
  Widget build(BuildContext context) {
    if (!listEquals(listSudokus, [])) {
      return ListView.builder(
          itemCount: listSudokus.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              textColor: Colors.black,
              onTap: () {
                callBack(listSudokus[index]);
              },
              leading: Text("ID : ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              title: Text(
                listSudokus[index].sudokuId,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          });
    } else {
      return Center(
        child: Text(
          "Aucun sudoku ${isFinished ? "terminé" : "en cours"}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
  }
}

int fillSquare(List<int> sudoku) {
  int fillSquare = 0;
  for (int i = 0; i < sudoku.length; i++) {
    if (sudoku[i] != -1) {
      fillSquare++;
    }
  }
  return fillSquare;
}
