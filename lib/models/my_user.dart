import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  const MyUser({
    required this.uid,
    required this.email,
    required this.photoURL,
    required this.lastSudoku,
    required this.sudokus,
  });

  final String uid;
  final String email;
  final String photoURL;
  final String lastSudoku;
  final List<String> sudokus;

  static const empty =
      MyUser(uid: '', email: '', sudokus: [], photoURL: '', lastSudoku: '');

  bool get isEmpty => this == MyUser.empty;

  bool get isNotEmpty => this != MyUser.empty;

  MyUser copyWith({
    String? uid,
    String? email,
    List<String>? sudokus,
    String? photoURL,
    String? lastSudoku,
  }) {
    return MyUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      sudokus: sudokus ?? this.sudokus,
      photoURL: photoURL ?? this.photoURL,
      lastSudoku: lastSudoku ?? this.lastSudoku,
    );
  }

  bool get isLastSudoku => lastSudoku != '';

  @override
  List<Object?> get props => [uid, email, sudokus, photoURL];
}
