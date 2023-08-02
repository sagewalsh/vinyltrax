import 'package:firebase_auth/firebase_auth.dart';
import 'inventory/database.dart';

class Authentication {
  static final auth = FirebaseAuth.instance;
  Authentication() {}

  static bool userSignedIn() {
    // auth.authStateChanges().listen((User? user) {
    //   if (user == null)
    //     print("User is currently signed out");
    //   else
    //     print("User is signed in");
    // });
    if (auth.currentUser == null) {
      return false;
    }
    return true;
  }

  static Future<bool> createAccount(String email, String password) async {
    print(email + ": " + password);
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print(credential.user!.uid);
      Database.createUser(credential.user!.uid, email).then((success) =>
          success ? Database.logIn(credential.user!.uid) : print("try again"));
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<bool> signIn(String email, String password) async {
    print(email + ": " + password);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print(credential.user!.uid);
      Database.logIn(credential.user!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return false;
  }

  static void signOut() async {
    await auth.signOut();
  }

  static String getId() {
    if (auth.currentUser != null) {
      return auth.currentUser!.uid;
    }
    return "";
  }

  // static void updateEmail(String email) async {
  //   await auth.currentUser
  //       ?.updateEmail(email)
  //       .then((value) async => await auth.currentUser?.sendEmailVerification());
  // }

  static Future<List<dynamic>> updateEmail(
    String email,
    String oldEmail,
    String password,
  ) async {
    var id = auth.currentUser!.uid;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: oldEmail,
        password: password,
      )
          .then((credential) async {
        if (credential.user?.uid == id) {
          await auth.currentUser?.updateEmail(email);
        }
      });
    } catch (e) {
      print("ERROR: " + e.toString());
      return [false, e.toString()];
    }
    return [true, ""];
  }

  static Future<List<dynamic>> updatePassword(
    String email,
    String oldPassword,
    String password,
  ) async {
    var id = auth.currentUser!.uid;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: oldPassword,
      )
          .then((credential) async {
        if (credential.user?.uid == id)
          await auth.currentUser?.updatePassword(password);
      });
    } catch (e) {
      print("ERROR: " + e.toString());
      return [false, e.toString()];
    }
    return [true, ""];
  }

  static void resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<List<dynamic>> deleteUser(String email, String password) async {
    var id = auth.currentUser!.uid;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (credential) async {
          if (credential.user?.uid == id) await auth.currentUser?.delete();
        },
      );
    } catch (e) {
      print("ERROR: " + e.toString());
      return [false, e.toString()];
    }
    return [true, ""];
  }
}
