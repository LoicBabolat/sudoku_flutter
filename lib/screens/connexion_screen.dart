import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_flutter/router/router.dart';
import 'package:sudoku_flutter/widgets/button_text_ui.dart';
import 'package:sudoku_flutter/widgets/loading_widget.dart';
import 'package:sudoku_flutter/data_to_screen/auth.dart';

class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({super.key});

  @override
  State<ConnexionScreen> createState() => _ConnexionScreen();
}

class _ConnexionScreen extends State<ConnexionScreen> {
  late final Auth _auth;
  late StreamSubscription<Map<String, dynamic>?> authStream;
  GoRouter goRouter = router;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _auth = Provider.of<Auth>(context, listen: false);
    authStream = _auth.user.listen((Map<String, dynamic>? user) {
      if (user != null) {
        _auth.signInDataBase().then((value) {
          if (_auth.firstStart) {
            goRouter.go('/create_sudoku');
            _auth.firstStart = false;
          }

          Provider.of<IsLoading>(context, listen: false).setLoading(false);
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    authStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return auth.currentUser!.isNotEmpty
            ? _userInfo()
            : _googleSignInButton();
      },
    );
  }

  Widget _googleSignInButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTextUI.whiteBorder(
            onPressed: () {
              Provider.of<IsLoading>(context, listen: false).setLoading(true);
              Provider.of<Auth>(context, listen: false).signInWithGoogle();

              //     .then((value) {
              //   Provider.of<IsLoading>(context, listen: false)
              //       .setLoading(false);
              // });
            },
            text: "Se connecter avec Google",
          ),
        ],
      ),
    );
  }

  Widget _userInfo() {
    return Center(
      child: Consumer<Auth>(builder: (context, auth, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundImage: NetworkImage(auth.currentUser!.photoURL)),
            Text(
              "${auth.currentUser!.email} est connecté",
              textAlign: TextAlign.center,
            ),
            ButtonTextUI.red(
                text: "Se déconnecter",
                onPressed: () {
                  Provider.of<IsLoading>(context, listen: false)
                      .setLoading(true);
                  auth.signOut().then((value) {
                    Provider.of<IsLoading>(context, listen: false)
                        .setLoading(false);
                  });
                }),
            ButtonTextUI.red(
                text: "Supprimer le compte",
                onPressed: () {
                  Provider.of<IsLoading>(context, listen: false)
                      .setLoading(true);
                  auth.deleteUser().then((value) {
                    Provider.of<IsLoading>(context, listen: false)
                        .setLoading(false);
                  });
                }),
          ],
        );
      }),
    );
  }
}
