import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_flutter/data_to_screen/auth.dart';
import 'package:sudoku_flutter/data_to_screen/sudoku_infos.dart';
import 'package:sudoku_flutter/models/my_sudoku.dart';
import 'package:sudoku_flutter/widgets/button_text_ui.dart';
import 'package:sudoku_flutter/widgets/sudoku_screen/dropdown_button_ui.dart';

class CreateSudokuScreen extends StatefulWidget {
  const CreateSudokuScreen({super.key});

  @override
  State<CreateSudokuScreen> createState() => _CreateSudokuScreenState();
}

class _CreateSudokuScreenState extends State<CreateSudokuScreen> {
  String difficultyCurrent = "Medium";
  List<String> difficultyChoices = ["Facile", "Medium", "Difficile", "Expert"];

  String errorIndicationCurrent = "Sans indication des erreurs";
  List<String> errorIndicationChoices = [
    "Sans indication des erreurs",
    "Avec indication des erreurs"
  ];

  String visuelHelpCurrent = "Avec aide visuelle";
  List<String> visuelHelpChoices = ["Avec aide visuelle", "Sans aide visuelle"];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonUI(
                choices: difficultyChoices,
                currentValue: difficultyCurrent,
                onChanged: (String value) {
                  setState(() {
                    difficultyCurrent = value;
                  });
                }),
            const SizedBox(
              height: 15,
            ),
            DropdownButtonUI(
                choices: errorIndicationChoices,
                currentValue: errorIndicationCurrent,
                onChanged: (String value) {
                  setState(() {
                    errorIndicationCurrent = value;
                  });
                }),
            const SizedBox(
              height: 15,
            ),
            DropdownButtonUI(
                choices: visuelHelpChoices,
                currentValue: visuelHelpCurrent,
                onChanged: (String value) {
                  setState(() {
                    visuelHelpCurrent = value;
                  });
                }),
            const SizedBox(
              height: 50,
            ),
            ButtonTextUI(
              onPressed: () {
                SudokuInfos.createSudoku(
                        difficultyCurrent,
                        Provider.of<Auth>(context, listen: false)
                            .currentUser!
                            .uid)
                    .then((value) {
                  //Provider.of<IsLoading>(context, listen: false).setLoading(true);
                  context.go('/create_sudoku/sudoku/$value');
                });
              },
              text: 'Lancer le Sudoku → ',
            ),
            // ButtonTextUI(
            //     onPressed: () {
            //       Provider.of<Auth>(context, listen: false).setAllUserSudokus();
            //     },
            //     text: "Set User Sudokus"),
            // SizedBox(
            //   width: 500,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: testAllSudokus(context),
            //   ),
            // )
            ButtonTextUI(
              onPressed: () {
                SudokuInfos.deleteAllSudoku();
              },
              text: 'Delete All Sudoku',
            )
          ],
        )),
      ],
    );
  }
}

List<Text> testAllSudokus(context) {
  List<MySudoku> sudokus =
      Provider.of<Auth>(context, listen: false).userSudokus ?? [];
  return sudokus
      .map((e) => Text(
            e.sudokuId,
            style: const TextStyle(fontSize: 20),
          ))
      .toList();
}
