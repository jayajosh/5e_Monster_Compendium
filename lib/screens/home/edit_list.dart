import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../components/item_views.dart';
import '../../services/monster_factory.dart';
//import 'package:share/share.dart';
//import '../../services/dynamic_link.dart';

final db = FirebaseFirestore.instance;

final MonsterRef = db.collection('Monsters');

class EditList extends StatefulWidget {

  @override
  _EditList createState() => _EditList();

}

class _EditList extends State<EditList> {
  TextEditingController _controller = new TextEditingController(text: "");
  //ScrollController _scrollController = new ScrollController(); //todo check and delete

  int loadedIndex = 0;

  var lastItem;

  String search = "";

  List bookmarked = [];

  createQuery() {
    var monsterQuery = MonsterRef.limit(20).where('creator_id', isEqualTo: FirebaseAuth.instance.currentUser?.uid.toString()).get();
    return monsterQuery;
  }

  popUpBuilder(doc){
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) {return popUpItems();},
      onSelected: (value) {
        if(value == "copy"){/*copy()*/}
        else if (value == "save"){/*save("${routes[index]["uid"]}-${routes[index]["routename"]}");*/}
        else if (value == "unsave"){/*unsave("${routes[index]["uid"]}-${routes[index]["routename"]}");*/}
        else if (value == "qr"){/*qr("${routes[index]["uid"]}","${routes[index]["routename"]}");*/}
        else if (value == "share"){/*share("${routes[index]["uid"]}","${routes[index]["routename"]}");*/}
        else {view(doc.id);}
      },
    );
  }

  popUpItems() {
    return [
      PopupMenuItem(value: "copy",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.copy)),
            Text("Copy to Homebrewery")
          ])),
      PopupMenuItem(value: "qr",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.qr_code)),
            Text("Generate QR")
          ])),
      PopupMenuItem(value: "share",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Transform(alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: Icon(Icons.reply))),
            Text("Share Monster")
          ])),
    ];
  }

  view(uid) async {
    if (!context.mounted) return; // Ensures context is valid
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(
          context, '/Home/MonsterView',
          arguments: [uid]);
    });
  }

  /* share(uid,routename) async {
    String link = await getLink(uid,routename);
    Share.share(link);
  }*/

  /*getLink(uid,routename) async {
    String link = await locator<DynamicLink>().createLink(uid,routename);
    */ /*final snack = SnackBar(
        content: Row(
            children:[Expanded(child: Text('$routename',overflow: TextOverflow.ellipsis,)),
              InkWell(onTap: (){Clipboard.setData(new ClipboardData(text: link));}, child: Text("Copy Link",style: TextStyle(color: Colors.blue)))]),
        behavior: SnackBarBehavior.floating );
    ScaffoldMessenger.of(context).showSnackBar(snack);*/ /*
    return link;
  }*/


  /// TODO BOOKMARKS \/\/
/*  save(uid){
    bookmarked.add(uid);
    Monsterdb.child("Users").child("${getUid()}").child("SavedRoutes").set(bookmarked);
  }

  unsave(uid){
    bookmarked.remove(uid);
    FirebaseDatabase.instance.reference().child("Users").child("${getUid()}").child("SavedRoutes").set(bookmarked);
  }

  setBookmarked()async{  await  FirebaseDatabase.instance.reference().child("Users").child("${getUid()}").child("SavedRoutes").once().then((snapshot) {
    bookmarked = List.from(snapshot.value);
  });
  }
*/
  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.addListener(() {
      setState(() {
        //routes = [];
        _controller = _controller;
      });
    });
    //routes = [];
    lastItem = null;
    //setBookmarked();
  }

  @override
  void initState() {
    super.initState();
    //setBookmarked();
  }

  @override
  Widget build(BuildContext context) {
    //todo refactor to match monster search
    createQuery();

    _controller.addListener(() {
      setState(() {
        search = _controller.text.toString();
      });
    });

    return FirestoreListView<MonsterStore>(
        query: createQuery(),
        pageSize: 20,
        emptyBuilder: (context) => Center(child: const Text('No data')),
        errorBuilder: (context, error, stackTrace) =>
            Center(child: Text(error.toString())),
        loadingBuilder: (context) => const CircularProgressIndicator(),
        itemBuilder: (context, doc) {
          final monster = doc.data();
          return MonsterSetupBasic(monster.cr!.toDouble(), monster.name!, () {
            view(doc.id);
          }, popUpBuilder(doc), context);
        }
    );
  }
}