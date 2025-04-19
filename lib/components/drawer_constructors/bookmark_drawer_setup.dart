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

  Query<MonsterStore>? getBookmarks(List bookmarks) {
    if (bookmarks.isNotEmpty) {
      var monsterQuery = MonsterRef.collection('Monsters').where(
          FieldPath.documentId, whereIn: bookmarks).withConverter(
          fromFirestore: (snapshot, _) =>
              MonsterStore.fromMap(snapshot.data()!),
          toFirestore: (MonsterStore, _) => MonsterStore.toMap());
      return monsterQuery;
    }
    return null;
  }

  getBody() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user?.saved_monsters != null) {
      var query = getBookmarks(userProvider.user!.saved_monsters);
      if (query != null) {
        return Expanded(
          child: FirestoreListView<MonsterStore>(
            query: query,
            pageSize: 20,
            emptyBuilder: (context) => const Text('No data'),
            errorBuilder: (context, error, stackTrace) =>
                Text(error.toString()),
            loadingBuilder: (context) => const CircularProgressIndicator(),
            itemBuilder: (context, doc) {
              final monster = doc.data();
              return Column(
                children: [
                  MonsterSetupBookmarks(
                      monster.cr!.toDouble(), monster.name!, () {
                    openBookmark(doc.id);
                  }, Icon(Icons.navigate_next), context),
                  Divider(thickness: 0.4),
                ],
              );
            },
          ),
        );
      }
    }
    return Expanded(child: Center(child: Text('No bookmarks found!')));
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
            child: Column(
              children: [Text('Bookmarked Monsters',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16),),
                Divider(),
                getBody()
              ],

            )
        )
    );
  }
}