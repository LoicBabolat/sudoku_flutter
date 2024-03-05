import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleFirebaseAuth {
  final FirebaseAuth _firebaseAuth;

  GoogleFirebaseAuth({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  OAuthCredential? credential;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((User? firebaseUser) {
      return firebaseUser;
    });
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<void> signIn() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().disconnect();
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
