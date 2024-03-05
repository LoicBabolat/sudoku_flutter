import 'package:flutter/material.dart';
import 'package:sudoku_flutter/widgets/button_icon_ui.dart';
import 'package:sudoku_flutter/widgets/button_text_ui.dart';

class ModalUI extends StatelessWidget {
  const ModalUI(
      {super.key,
      required this.textModal,
      required this.closeFunction,
      required this.bottomButonFunction,
      required this.buttonText,
      this.heightModal});

  final String textModal;
  final void Function() closeFunction;
  final void Function() bottomButonFunction;
  final String buttonText;
  final double? heightModal;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4.0),
                width: MediaQuery.of(context).size.width * 0.80,
                height: heightModal ?? 250,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 3.0)),
                          child: Center(
                            child: Text(
                              textModal,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: ButtonIconUI(
                            icon: Icons.close,
                            iconSize: 25,
                            padding: const EdgeInsets.all(2.0),
                            onPressed: closeFunction,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonTextUI(
                            margin: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                            onPressed: bottomButonFunction,
                            text: buttonText),
                      ),
                    ],
                  ),
                ]),
              ),
            )));
  }
}
