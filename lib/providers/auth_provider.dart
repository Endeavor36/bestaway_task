import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  Future signIn(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'Authentication failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password is incorrent for this email';
      }
      showErrorDialog(errorMessage, context);
    }
  }

  Future signUp(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'Authentication failed';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email already in use';
      }
      showErrorDialog(errorMessage, context);
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.pop(ctx);
            },
          )
        ],
      ),
    );
  }
}
