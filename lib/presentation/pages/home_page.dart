import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  Future<void> testFunction() async {
    final ref = FirebaseDatabase.instance.ref();
    final uid = _user!.uid;
    // final isExistingUid = await ref.child('users/testUser').get();
    // if (!isExistingUid.exists) {
    //final existingUsers = await ref.child('users/users/testUser').get();
    // final Map<dynamic, dynamic>? existingUsersValue =
    //     existingUsers.value as Map<dynamic, dynamic>?;
    // existingUsersValue!.addEntries({
    //   uid: {
    //     "sudokus": {"sudoku1": 1, "sudoku2": 2},
    //     "username": "lobab409"
    //   }
    // }.entries);
    //await ref.child('users').set(json);
    //   debugPrint(isExistingUid.value.toString());
    // }
    // await ref.child('users/l2UtPFZ2eIRWxUwBaJRffToghUe2').set(uid);
    //final snapshot =
    //await ref.child('users/l2UtPFZ2eIRWxUwBaJRffToghUe2').get();
    // if (snapshot.exists) {
    //   print(snapshot.value);
    // } else {
    //   print('No data available.');
    // }

    // New Sudoku //
    /* 
    final newPostSudokuKey = await ref.child("sudokus").push().key;
    await ref.child("sudokus/$newPostSudokuKey").set("newSudokuValue");

    await ref.child('users/$uid/sudokus').push().set(newPostSudokuKey);

    final sudokuRequest = await ref.child('users/$uid/sudokus').get();

    Map<dynamic, dynamic> sudokuMap =
        sudokuRequest.value as Map<dynamic, dynamic>;

    List<dynamic> sudokuList = sudokuMap.values.toList();
    print(sudokuList);
     */

    final userData = await ref.child('users/$uid').get();
    if (userData.exists) {
      print("déjà existant, data : ${userData.value}");
    } else {
      ref.child('users/$uid').update({
        "uid": uid,
        "email": _user!.email,
        "sudokus": [],
      });
      print("new User, data : ${userData.value}");
    }

    final newPostSudokuKey = await ref.child("sudokus").push().key;
    await ref.child("sudokus/$newPostSudokuKey").set({
      "id": newPostSudokuKey,
      "user": uid,
      "firstState": "firstState",
      "currentState": "currentState",
      "lastTries": ["firstTry", "secondTry"],
      "solution": "solution",
      "state": "pas commencé",
      "time": ["firstTryTime", "secondTryTime", "currentTryTime"],
      "notes": "notes",
    });

    await ref.child('users/$uid/sudokus').push().set(newPostSudokuKey);

    final sudokuRequest = await ref.child('users/$uid/sudokus').get();

    Map<dynamic, dynamic> sudokuMap =
        sudokuRequest.value as Map<dynamic, dynamic>;

    // await ref.child('users/$uid/sudoku').push().set(newPostSudoku);
    // final dataUid = await ref.child('users/$uid').get();
    // if (dataUid.exists) {
    //   print(dataUid.value);
    // } else {
    //   print('No data available.');
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _user = user;
        });
        debugPrint('User is currently signed out!');
      } else {
        _user = user;
        setState(() {
          _user = user;
        });
        debugPrint('User is signed in!');
        testFunction();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Sign In"),
      ),
      body: _user != null ? _userInfo() : _googleSignInButton(),
    );
  }

  Widget _googleSignInButton() {
    return const Center(
      child: SizedBox(
        height: 50,
        child: MaterialButton(
          color: Colors.white,
          elevation: 4,
          onPressed: signInWithGoogle,
          child: Text("Se connecter avec Google"),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(_user!.photoURL!),
          ),
          // Image(
          //   image: NetworkImage()),
          Text("${_user!.email} est connecté"),
          Text(_user!.displayName ?? ""),
          Text(_user!.uid),
          MaterialButton(
              color: Colors.red,
              child: Text("Se déconnecter"),
              onPressed: _handleGoogleSignOut)
        ],
      ),
    );
  }

  void _handleGoogleSignOut() {
    try {
      GoogleSignIn().disconnect();
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
    } catch (e) {
      print("$e");
    }
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
