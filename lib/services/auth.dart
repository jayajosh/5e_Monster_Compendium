import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:monster_compendium/components/platform_dialog.dart';
//import 'package:monster_compendium/services/picture_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';
import 'firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final uid = _auth.currentUser?.uid;

bool loggedIn(){
  if (_auth.currentUser != null) {
    return true;
  } else {
    return false;
  }
}

void registration(context, String username, String email, String password) async{
  if(password.length <= 5) {snackMessage(context,'The password must be at least 6 characters.');}
  else if(!email.contains('@')) {snackMessage(context,'The email is invalid.');}
  else {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      await _auth.currentUser!.updateProfile(displayName: username);
      await setUser();
      userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if (loggedIn() == true){SchedulerBinding.instance.addPostFrameCallback((_) async {
        Navigator.pushNamedAndRemoveUntil(context, "/Splash", (routes) => false);
      });}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackMessage(context,'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        snackMessage(context,'The account already exists for that email.');
      }
    } catch (e) {
      snackMessage(context, e);
    }
  }
}

void login(context, String email, String password) async{
  if (password.length <= 5) {snackMessage(context,'Password too short.');}
  else {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if (loggedIn() == true) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          Navigator.pushNamedAndRemoveUntil(
              context, "/Splash", (routes) => false);
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackMessage(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        snackMessage(context, 'Wrong password provided for that user.');
      } else {
        snackMessage(context, 'Incorrect details.');
      }
    }
  }
}

logout(context) {
  FirebaseAuth.instance.signOut();
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    Navigator.pushNamedAndRemoveUntil(context, "/Splash", (routes) => false);
  });
}


String? getUid(){
  return _auth.currentUser?.uid;
}

String? getUsername(){
  return _auth.currentUser?.displayName;
}

/*
Future getProfile(uid) async{
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users").child("$uid");
  Map<String,dynamic> profile;
  await dbRef.once().then((DataSnapshot snapshot)
  {
    profile = Map<String, dynamic>.from(snapshot.value);
  }
  );
  return profile;
}
*/
String? getPicture(){
  return _auth.currentUser?.photoURL;
}

wipePhoto() async{
  _auth.currentUser?.updateProfile(photoURL: null);
}
/*
setPicture(file) async {
  final url = await PictureGet();
  await _auth.currentUser.updateProfile(photoURL: url);
  await FirebaseDatabase.instance.reference().child("Users").child(_auth.currentUser.uid).child("PhotoUrl").set(url);
}
*/
userSetup (uid,username){
  return {
    "username": username,
    "image_url": null,
    "bio": null,
    "saved_monsters": [],
    "liked_monsters": [],
  };
}

setUser() async {await storageRef.collection("Users").doc(_auth.currentUser?.uid).set(userSetup(_auth.currentUser?.uid,_auth.currentUser?.displayName));}

resetPass(email){
  _auth.sendPasswordResetEmail(email: email);
}

loadUser() async {
  final userDoc = await storageRef.collection("Users").doc(_auth.currentUser?.uid).get();
  return userDoc.data();
}