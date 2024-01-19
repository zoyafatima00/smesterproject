import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'FirebaseOperations.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String userUid="";
  String get getUserUid => userUid;
  Future logIntoAccount(String email,String password)async{
    UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    User? user= userCredential.user;
    userUid=user!.uid;
    print("User-UID in Authentication: $userUid");

    notifyListeners();
  }
  Future createAccount(String email,String password)async{
    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User? user= userCredential.user;
    userUid=user!.uid;
    print('Created Account Uid=>userUid');
    notifyListeners();
  }

  Future logOutViaEmail(){
    return firebaseAuth.signOut();
  }

  Future signInWithGoogle(BuildContext context) async{
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
    );

    final UserCredential userCredential = await firebaseAuth.signInWithCredential(
        authCredential
    );
    final User? user = userCredential.user;
    assert(user!.uid !=null);

    userUid=user!.uid;

    // Store user data in Firestore
    Map<String, dynamic> userData = {
      'useremail': user.email,
      'userimage': user.photoURL,
      'username': user.displayName,
      'userpassword': null, // Password should not be stored as it's managed by Google
      'useruid': user.uid,
    };

    await Provider.of<FirebaseOperations>(context, listen: false).createUserCollection(context, userData);


    print("Google user Uid => $userUid");
    notifyListeners();
  }

  Future signOutWithGoogle()async{
    return googleSignIn.signOut();

  }


}
