import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
//import 'services/picture_selector.dart';
//import 'services/picture_storage.dart';
import '../../services/monster_factory.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import '../../services/themes.dart';
import 'package:url_launcher/url_launcher.dart';


class BookmarkDrawerSetup extends StatefulWidget {
  @override
  _BookmarkDrawerSetupState createState() => new _BookmarkDrawerSetupState();
}

class _BookmarkDrawerSetupState extends State<BookmarkDrawerSetup> {

  List bookmarks = [];
  final MonsterRef = FirebaseFirestore.instance;

  Widget HeaderSetup() {
    return SizedBox();
  }

  Widget ItemSetup(IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Query<MonsterStore> getBookmarkIDs() {

        var monsterQuery = MonsterRef.collection('Monsters').where(FieldPath.documentId, whereIn: bookmarks).withConverter(
            fromFirestore: (snapshot, _) => MonsterStore.fromMap(snapshot.data()!),
            toFirestore: (MonsterStore, _) => MonsterStore.toMap());
    return monsterQuery;
  }

    Future<List> getBookmarks() async {
    if (bookmarks.isEmpty) {
      var doc = await MonsterRef.collection('Users').doc(getUid()).get();
      bookmarks = doc.get('SavedMonsters');
      return bookmarks;
    }
    else{return bookmarks;}
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
          child: FutureBuilder<List>(
              future: getBookmarks(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if(bookmarks.isEmpty){
                  return Center(child: Text('Bookmarks not found'));
                }
                  return FirestoreListView<MonsterStore>(
                    query: getBookmarkIDs(),
                    pageSize:20,
                    emptyBuilder: (context) => const Text('No data'),
                    errorBuilder: (context, error, stackTrace) => Text(error.toString()),
                    loadingBuilder: (context) => const CircularProgressIndicator(),
                    itemBuilder: (context, doc) {
                      final monster = doc.data();
                      return Text('${monster.cr!.toDouble()},${monster.name!}');
                    },
                  );
                }


          ),
        ));
  }
}