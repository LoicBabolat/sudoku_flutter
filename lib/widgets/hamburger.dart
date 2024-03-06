import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_flutter/data_to_screen/auth.dart';

class Hamburger extends StatelessWidget {
  const Hamburger({super.key, required this.closeBurger, required this.router});

  final void Function() closeBurger;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        right: 0,
        left: 0,
        bottom: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (Provider.of<Auth>(context, listen: false)
                    .currentUser!
                    .lastSudoku !=
                "") ...[
              HamburgerTile(
                  firstLine: "REPRENDRE",
                  secondLine: "SUDOKU",
                  onTap: () {
                    router.go(
                        "/create_sudoku/sudoku/${Provider.of<Auth>(context, listen: false).currentUser!.lastSudoku}");
                    closeBurger();
                  },
                  color: Theme.of(context).colorScheme.background,
                  textColor: Colors.black),
            ],
            HamburgerTile(
              firstLine: "NOUVEAU",
              secondLine: "SUDOKU",
              onTap: () {
                router.go("/create_sudoku");
                closeBurger();
              },
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
            ),
            HamburgerTile(
                firstLine: "SUDOKUS",
                secondLine: "EN COURS",
                onTap: () {
                  Provider.of<Auth>(context, listen: false).setAllUserSudokus();
                  router.go("/sudoku_list/false");
                  closeBurger();
                },
                color: Theme.of(context).colorScheme.background,
                textColor: Colors.black),
            HamburgerTile(
              firstLine: "SUDOKUS",
              secondLine: "TERMINÉS",
              onTap: () {
                Provider.of<Auth>(context, listen: false).setAllUserSudokus();
                router.go("/sudoku_list/true");
                closeBurger();
              },
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
            ),
            HamburgerTile(
                firstLine: "PARAMÈTRES",
                secondLine: "",
                onTap: () {
                  closeBurger();
                },
                color: Theme.of(context).colorScheme.background,
                textColor: Colors.black),
          ],
        ));
  }
}

class HamburgerTile extends StatelessWidget {
  const HamburgerTile(
      {super.key,
      required this.firstLine,
      required this.secondLine,
      required this.onTap,
      required this.color,
      required this.textColor});

  final String firstLine;
  final String secondLine;
  final void Function() onTap;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: color,
                border: const Border(
                    top: BorderSide(color: Colors.black, width: 5))),
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.07, 2, 0, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      firstLine,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: textColor,
                          ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      secondLine,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: textColor,
                          ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
