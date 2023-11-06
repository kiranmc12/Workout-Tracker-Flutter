import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workoutapp/functions/user_db.dart';
import 'package:workoutapp/screens/bottom_nav.dart';

signup(String email, String password,String username, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
    await FirebaseAuth.instance.currentUser!.updateEmail(email);
    await FirestoreServices.saveUser(username, email, credential.user!.uid);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(), 
      ),
    );

    Fluttertoast.showToast(
      msg: "Sign-up Successful!",
      backgroundColor: Colors.green,
    );
  } on FirebaseAuthException catch (e) {
    
      if (e.code == 'weak-password') {
        
      } else if (e.code == 'email-already-in-use') {
      
      } else if (e.code == 'user-not-found') {
        
      } else if (e.code == 'wrong-password') {
      
      }
      print(e.code);
    
    } catch (e) {
      print(e);
    }
}

signIn(String email, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
     Fluttertoast.showToast(
      msg: "Sign-In Successful!",
      backgroundColor: Colors.green,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const NavPage(), //
      ),
    );
  }  on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
      } else if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {
      }
      print(e.code);//Add this line to see other firebase exceptions.
    } catch (e) {
      print(e);
    }
}


signOut() async {
  await FirebaseAuth.instance.signOut();
}