
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserStore {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? username;
  String? bio;
  String? image_url;
  List<String> saved_monsters = [];
  List<String> liked_monsters = [];



  UserStore({
    this.username,
    this.bio,
    this.image_url,
    required this.saved_monsters,
    required this.liked_monsters,

  });

  factory UserStore.fromMap(Map<String, dynamic> map) {
    return UserStore(
      username: map['username'],
      bio: map['bio'],
      image_url: map['image_url'],
      saved_monsters: (map['saved_monsters'] as List<dynamic>).cast<String>().toList(),
      liked_monsters: (map['liked_monsters'] as List<dynamic>).cast<String>().toList(),
    );
  }

  Map<String, dynamic> toMap() {
    //Converts to a map for firestore upload
    return {
      'username': username,
      'bio': bio,
      'image_url': image_url,
      'saved_monsters': saved_monsters,
      'liked_monsters': liked_monsters,
    };
  }

  create(context,userMap) async {
    final db = FirebaseFirestore.instance;
    //image_url = await storeChild(uid,image,context); //todo decide whether to wait or not
    db.collection('Monsters').doc(uid).set(userMap)
        .onError((e, _) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error writing document: $e"),
      duration: const Duration(seconds: 5),
    )));

  }

  update(context,Map monsterMap) async {
    final db = FirebaseFirestore.instance;
    //image_url = await storeChild(uid,image,context); //todo decide whether to wait or not
    var uploadMonsterMap = monsterMap.cast<Object,Object>();
    db.collection('Users').doc(uid).update(uploadMonsterMap)
        .onError((e, _) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error writing document: $e"),
      duration: const Duration(seconds: 5),
    )));

  }

    validate(context){
      Map userMap = toMap();
      final validation = ['username','bio'];
      String missing = '';
      for (var field in validation) {
        if(userMap[field] == null){
          missing += '$field, ';
      }
      }
      if(missing == '') {
        update(context, userMap);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Missing fields: ${missing.substring(0,missing.length-2)}")));}
    }
}