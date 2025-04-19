import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'services/picture_selector.dart';
//import 'services/picture_storage.dart';
import '../../services/monster_factory.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

import '../../services/user_provider.dart';
import '../item_views.dart';


class BookmarkDrawerSetup extends StatefulWidget {
  @override
  _BookmarkDrawerSetupState createState() => new _BookmarkDrawerSetupState();
}

class _BookmarkDrawerSetupState extends State<BookmarkDrawerSetup> {

  final MonsterRef = FirebaseFirestore.instance;

  openBookmark(uid) async {
    if (!context.mounted) return; // Ensures context is valid
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(
          context, '/Home/MonsterView',
          arguments: [uid]);
    });
  }

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

  Query<MonsterStore> getBookmarks(bookmarks) {
    if (bookmarks != null) {
      var monsterQuery = MonsterRef.collection('Monsters').where(FieldPath.documentId, whereIn: bookmarks).withConverter(
          fromFirestore: (snapshot, _) => MonsterStore.fromMap(snapshot.data()!),
          toFirestore: (MonsterStore, _) => MonsterStore.toMap());
      return monsterQuery;
    }
    var monsterQuery = MonsterRef.collection('Monsters').where(FieldPath.documentId, whereIn: bookmarks).withConverter(
        fromFirestore: (snapshot, _) => MonsterStore.fromMap(snapshot.data()!),
        toFirestore: (MonsterStore, _) => MonsterStore.toMap());
    return monsterQuery;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user?.saved_monsters != null) {
      return Drawer(
          child: SafeArea(
            child: FirestoreListView<MonsterStore>(
              query: getBookmarks(userProvider.user?.saved_monsters),
              pageSize: 20,
              emptyBuilder: (context) => const Text('No data'),
              errorBuilder: (context, error, stackTrace) =>
                  Text(error.toString()),
              loadingBuilder: (context) => const CircularProgressIndicator(),
              itemBuilder: (context, doc) {
                final monster = doc.data();
                return MonsterSetupBookmarks(monster.cr!.toDouble(),monster.name!,(){openBookmark(doc.id);},Icon(Icons.navigate_next),context);
              },
            ),
          )
      );
    }
    else{
      return Drawer(
          child: SafeArea(
            child: Center(child:Text('No bookmarks found!')), //todo add some hint text on how to save a bookmark
          )
      );
    }
  }
}