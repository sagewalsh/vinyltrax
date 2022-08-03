import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final auth = FirebaseAuth.instance;
  Authentication() {}

  void userSignedIn() {
    auth.authStateChanges().listen((User? user) {
      if (user == null)
        print("User is currently signed out");
      else
        print("User is signed in");
    });
  }

  void createAccount(String email, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    await auth.currentUser?.sendEmailVerification();
  }

  void signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void signOut() async {
    await auth.signOut();
  }

  String getUser() {
    if (auth.currentUser != null) {
      return auth.currentUser!.uid;
    }
    return "";
  }

  void updateEmail(String email) async {
    await auth.currentUser
        ?.updateEmail(email)
        .then((value) async => await auth.currentUser?.sendEmailVerification());
  }

  void updatePassword(String newPassword) async {
    await auth.currentUser?.updatePassword(newPassword);
  }

  void resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  void deleteUser() async {
    await auth.currentUser?.delete();
  }
}
