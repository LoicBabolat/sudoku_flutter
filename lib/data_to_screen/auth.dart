import 'package:flutter/material.dart';
import 'package:sudoku_flutter/data/database/sudoku/entities/firebase_data_sudoku.dart';
import 'package:sudoku_flutter/data/database/user/firebase_data_user.dart';
import 'package:sudoku_flutter/data/user_auth/google_firebase_auth.dart';
import 'package:sudoku_flutter/models/my_sudoku.dart';
import 'package:sudoku_flutter/models/my_user.dart';

class Auth extends ChangeNotifier {
  final GoogleFirebaseAuth _googleFirebaseAuth;
  final FirebaseDataUser _firebaseDataUser;
  MyUser _currentUser = MyUser.empty;
  bool firstStart = true;
  List<MySudoku>? userSudokus;

  Auth(
      {GoogleFirebaseAuth? googleFirebaseAuth,
      FirebaseDataUser? firebaseDataUser})
      : _googleFirebaseAuth = googleFirebaseAuth ?? GoogleFirebaseAuth(),
        _firebaseDataUser = firebaseDataUser ?? FirebaseDataUser();

  Future<void> signInWithGoogle() async {
    await _googleFirebaseAuth.signIn();
  }

  Future<void> signInDataBase() async {
    await _firebaseDataUser.createUser(getGoogleSignInUser());
    await setCurrentUser();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _googleFirebaseAuth.signOut();
    _currentUser = MyUser.empty;
    notifyListeners();
  }

  Future<void> deleteUser() async {
    await _firebaseDataUser.deleteUser(getGoogleSignInUser().uid);
    await signOut();
    notifyListeners();
  }

  Stream<Map<String, dynamic>?> get user {
    return _googleFirebaseAuth.user.map((myUser) {
      if (myUser != null) {
        return {
          "uid": myUser.uid,
          "email": myUser.email ?? "",
          "photoUrl": myUser.photoURL ?? "",
        };
      } else {
        return null;
      }
    });
  }

  Future<void> setCurrentUser() async {
    _currentUser = await _firebaseDataUser.getUser(getGoogleSignInUser().uid);
    notifyListeners();
  }

  MyUser? get currentUser {
    return _currentUser;
  }

  MyUser getGoogleSignInUser() {
    return _googleFirebaseAuth.currentUser != null
        ? MyUser(
            uid: _googleFirebaseAuth.currentUser!.uid,
            email: _googleFirebaseAuth.currentUser!.email ?? "",
            photoURL: _googleFirebaseAuth.currentUser!.photoURL ?? "",
            lastSudoku: "",
            sudokus: const [])
        : MyUser.empty;
  }

  Future<void> chgeLastSudoku(String sudokuId) async {
    await _firebaseDataUser.chgeLastSudoku(getGoogleSignInUser().uid, sudokuId);
    setCurrentUser();
    notifyListeners();
  }

  void updateUser() {}

  Future<void> setAllUserSudokus() async {
    FirebaseDataSudoku fireBaseDataSudoku = FirebaseDataSudoku();
    userSudokus = await fireBaseDataSudoku.allUserSudokus(_currentUser.sudokus);
    notifyListeners();
  }
}
