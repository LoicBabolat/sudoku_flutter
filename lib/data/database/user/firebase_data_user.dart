import 'package:firebase_database/firebase_database.dart';
import 'package:sudoku_flutter/models/my_user.dart';

class FirebaseDataUser {
  final ref = FirebaseDatabase.instance.ref();

  Future<void> createUser(MyUser dataUserModel) async {
    final userData = await ref.child('users/${dataUserModel.uid}').get();
    if (dataUserModel.isNotEmpty) {
      if (userData.exists) {
        print("déjà existant, data : ${userData.value}");
      } else {
        await ref.child('users/${dataUserModel.uid}').update({
          "uid": dataUserModel.uid,
          "email": dataUserModel.email,
          "photoURL": dataUserModel.photoURL,
          "lastSudoku": dataUserModel.lastSudoku,
          "sudokus": dataUserModel.sudokus,
        });
        print("new User, data : ${userData.value}");
      }
    } else {
      print("dataUserModel is empty");
    }
  }

  Future<MyUser> getUser(String userId) async {
    final userData = await ref.child('users/$userId').get();
    if (userData.exists) {
      final Map<dynamic, dynamic> userValue =
          userData.value as Map<dynamic, dynamic>;
      return MyUser(
          uid: userValue["uid"],
          email: userValue["email"],
          photoURL: userValue["photoURL"],
          lastSudoku: userValue["lastSudoku"] ?? "",
          sudokus:
              List<String>.from(userValue["sudokus"].values.toList() ?? []));
    } else {
      return MyUser.empty;
    }
  }

  //  List<List<bool>>.from(map["notes"].map((e) => List<bool>.from(e))  //

  Future<void> deleteUser(String userId) async {
    final userData = await ref.child('users/$userId').get();
    if (userData.exists) {
      ref.child('users/$userId').remove();
      print("user deleted");
    } else {
      print("user not found");
    }
  }

  Future<void> updateUser(
      {required String newEmail,
      required String newUid,
      required String newPhotoUrl,
      required String userId}) async {
    final userData = await ref.child('users/$userId').get();
    if (userData.exists) {
      ref.child('users/$userId/uid').set(newUid);
      ref.child('users/$userId/email').set(newEmail);
      ref.child('users/$userId/photoURL').set(newPhotoUrl);
      print("user updated");
    } else {
      print("user not found");
    }
  }

  Future<void> chgeLastSudoku(String userId, String newLastSudoku) async {
    final userData = await ref.child('users/$userId').get();
    if (userData.exists) {
      ref.child('users/$userId/lastSudoku').set(newLastSudoku);
      print("lastSudoku changed");
    } else {
      print("user not found");
    }
  }

  Future<void> addUserSudoku(String userId, String newSudokuKey) async {
    final userData = await ref.child('users/$userId').get();
    if (userData.exists) {
      await ref.child('users/$userId/sudokus').push().set(newSudokuKey);
      print("add a sudoku to the user");
    } else {
      print("user not found");
    }
  }

  Future<void> removeUserSudoku(
    String userId,
    String removeSudokuKey,
  ) async {
    final sudokuData = await ref.child('users/$userId/remove').get();
    if (sudokuData.exists) {
      final Map<String, String> sudokuValue =
          sudokuData.value as Map<String, String>;
      sudokuValue.entries
          .toList()
          .removeWhere((element) => element.value == removeSudokuKey);
      ref.child('users/$userId/sudokus').set(sudokuValue);
    } else {
      print("Aucun sudoku trouvé pour cet utilisateur");
    }
  }

  Future<List<String>?> getUserSudoku(String userId) async {
    final sudokuData = await ref.child('users/$userId/remove').get();
    if (sudokuData.exists) {
      final Map<String, String> sudokuValue =
          sudokuData.value as Map<String, String>;
      return sudokuValue.values.toList();
    } else {
      print("Aucun sudoku trouvé pour cet utilisateur");
      return [];
    }
  }
}
