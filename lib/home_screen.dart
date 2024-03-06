import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_flutter/router/router.dart';
import 'package:sudoku_flutter/widgets/button_icon_ui.dart';
import 'package:sudoku_flutter/widgets/hamburger.dart';
import 'package:sudoku_flutter/widgets/loading_widget.dart';
import 'package:sudoku_flutter/data_to_screen/auth.dart';
import 'package:sudoku_flutter/widgets/modal_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.child});

  final Widget child;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isModalClosed = false;
  GoRouter goRouter = router;
  bool isHamburger = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Auth auth = Provider.of<Auth>(context, listen: false);
    auth.user.listen((Map<String, dynamic>? user) {
      if (user != null) {
        auth.signInDataBase().then((value) {
          if (auth.firstStart) {
            setState(() {});
            goRouter.go('/create_sudoku');
            auth.firstStart = false;
          }
        });
      } else {
        goRouter.go('/connexion');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => IsLoading(),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: SizedBox(
                child: Row(
                  children: [
                    ButtonIconUI(
                      onPressed: () {
                        setState(() {
                          isHamburger = !isHamburger;
                          isModalClosed = true;
                        });
                      },
                      icon: !isHamburger ? Icons.menu : Icons.close,
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "SUDOKU",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ButtonIconUI(
                      onPressed: () {
                        setState(() {
                          isHamburger = false;
                          isModalClosed = true;
                        });
                        goRouter.push('/connexion');
                      },
                      icon: Icons.person,
                    ),
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: Consumer<IsLoading>(
              builder: (context, loading, child) {
                return LoadingWidget(
                    IsLoading: loading.getLoading(),
                    child: Stack(children: [
                      widget.child,
                      if (Provider.of<Auth>(context, listen: false)
                              .currentUser!
                              .isLastSudoku &&
                          !isModalClosed) ...[
                        ModalUI(
                            textModal: "Reprendre le dernier Sudoku ?",
                            buttonText: "Reprendre",
                            closeFunction: () {
                              setState(() {
                                isModalClosed = true;
                              });
                            },
                            bottomButonFunction: () {
                              setState(() {
                                isModalClosed = true;
                              });
                              goRouter.go(
                                  "/create_sudoku/sudoku/${Provider.of<Auth>(context, listen: false).currentUser!.lastSudoku}");
                            })
                      ],
                      if (isHamburger) ...[
                        Hamburger(
                            router: goRouter,
                            closeBurger: () {
                              Provider.of<Auth>(context, listen: false)
                                  .userSudokus = null;
                              setState(() {
                                isHamburger = false;
                              });
                            })
                      ]
                    ]));
              },
            ),
          );
        });
  }
}
