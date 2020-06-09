import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  var ref = Firestore.instance.collection('users').document(user.email);
  var subjects = [];

  await ref.get().then((snapshot) async {
    if (!snapshot.exists) {
      await ref.setData({'subjects': subjects, 'email': user.email});
    }
  });

  return user;
}

signOutGoogle(context) async {
  await _auth.signOut().then((val) async {
    await googleSignIn.signOut();
    Navigator.of(context).pushReplacementNamed("landingpage");
  }).catchError((e) {
    print(e);
  });
}

getCurrentUser() async {
  FirebaseUser user = await _auth.currentUser();

  return user;
}
