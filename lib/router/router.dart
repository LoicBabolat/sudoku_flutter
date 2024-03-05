import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_flutter/screens/sudokus_list_screen.dart';
import 'package:sudoku_flutter/screens/waiting_screen.dart';

import '/screens/connexion_screen.dart';
import '/screens/create_sudoku_screen.dart';
import '/screens/sudoku_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/waiting_screen',
  routes: <RouteBase>[
    GoRoute(
      path: '/waiting_screen',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeTransitionPage(
          child: const WaitingScreen(),
          key: state.pageKey,
        );
      },
    ),
    GoRoute(
      path: '/connexion',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeTransitionPage(
          child: const ConnexionScreen(),
          key: state.pageKey,
        );
      },
    ),
    GoRoute(
      path: '/sudoku_list/:isFinished',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeTransitionPage(
          child: SudokusListScreen(
              isFinished: bool.parse(state.pathParameters['isFinished']!)),
          key: state.pageKey,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'sudoku/:sudokuId',
          builder: (BuildContext context, GoRouterState state) {
            return SudokuScreen(
              sudokuId: state.pathParameters['sudokuId'],
            );
          },
        )
      ],
    ),
    GoRoute(
      path: '/create_sudoku',
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          child: const CreateSudokuScreen(),
          key: state.pageKey,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'sudoku/:sudokuId',
          builder: (BuildContext context, GoRouterState state) {
            return SudokuScreen(
              sudokuId: state.pathParameters['sudokuId'],
            );
          },
        )
      ],
    ),
  ],
  // redirect: (BuildContext context, GoRouterState state) {
  //   MyUser? currentUser =
  //       Provider.of<Auth>(context, listen: false).currentUser;
  //   debugPrint("currentUser.isEmpty: ${currentUser!.isEmpty}");
  //   if (currentUser!.isEmpty && state.fullPath != '/connexion') {
  //     return '/connexion';
  //   } else if (currentUser.isNotEmpty && state.fullPath == '/connexion') {
  //     return '/create_sudoku';
  //   }
  //   return null;
  // }
);

class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
            key: key,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
                  opacity: animation.drive(_curveTween),
                  child: child,
                ),
            child: child);

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}
