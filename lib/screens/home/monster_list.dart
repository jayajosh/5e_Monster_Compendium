import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../components/item_views.dart';
import '../../locator.dart';
import '../../services/auth.dart';
//import 'package:share/share.dart';
import '../../services/active_filters.dart';
import '../../services/monster_factory.dart';
//import '../../services/dynamic_link.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

import '../../services/user_provider.dart';

final db = FirebaseFirestore.instance;

final MonsterRef = db.collection('Monsters');

class MonsterList extends StatefulWidget {
  const MonsterList({Key? key}) : super(key: key);

  @override
  _MonsterList createState() => _MonsterList();

}

class _MonsterList extends State<MonsterList> {
  TextEditingController _controller = new TextEditingController(text: "");
  /*ScrollController _scrollController = new ScrollController();
  List<QueryDocumentSnapshot> _monsterList = [];
  int loadedIndex = 0;
  var lastItem;*/

  String search = "";
  late UserProvider userProvider;

  createQuery() {
    Query<MonsterStore> monsterQuery = MonsterRef.withConverter(
        fromFirestore: (snapshot, _) => MonsterStore.fromMap(snapshot.data()!),
        toFirestore: (MonsterStore, _) => MonsterStore.toMap()
    );
    locator<ActiveFilters>().getOn() ?
    monsterQuery = MonsterRef //todo get from list?
        .where('cr', isGreaterThanOrEqualTo: locator<ActiveFilters>().crmin)
        .where('cr', isLessThanOrEqualTo: locator<ActiveFilters>().crmax)
        .where('size', isEqualTo: locator<ActiveFilters>().size)
        .where('type', isEqualTo: locator<ActiveFilters>().type)
        .where('alignment', isEqualTo: locator<ActiveFilters>().alignment)  // todo split into 2 categories?
        .withConverter(
        fromFirestore: (snapshot, _) => MonsterStore.fromMap(snapshot.data()!),
        toFirestore: (MonsterStore, _) => MonsterStore.toMap()
    )
        : monsterQuery = MonsterRef.withConverter(
    fromFirestore: (snapshot, _) => MonsterStore.fromMap(snapshot.data()!),
    toFirestore: (MonsterStore, _) => MonsterStore.toMap()
    );;
    return monsterQuery;/*var monsterQuery = MonsterRef.limit(20).get();
    locator<ActiveFilters>().getOn() ?
    monsterQuery = MonsterRef//.startAfterDocument(_monsterList.last)
        .where('cr', isGreaterThanOrEqualTo: locator<ActiveFilters>().crmin)
        .where('cr', isLessThanOrEqualTo: locator<ActiveFilters>().crmax)
        .limit(20)
        .get()
        : monsterQuery = MonsterRef.limit(20).get();
    return monsterQuery;*/
  }

  popUpBuilder(doc){
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) {return popUpItems(doc.id);},
      onSelected: (value) {
        if(value == "copy"){/*copy()*/}
        else if (value == "save"){save(doc.id);}
        else if (value == "unsave"){unsave(doc.id);}
        else if (value == "qr"){/*qr("${routes[index]["uid"]}","${routes[index]["routename"]}");*/}
        else if (value == "share"){/*share("${routes[index]["uid"]}","${routes[index]["routename"]}");*/}
        else {view(doc.id);}
      },
    );
  }

  popUpItems(monsterId) {
    return [
      PopupMenuItem(value: "copy",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.copy)),
            Text("Copy to Homebrewery")
          ])),
      bookmarkCheck(monsterId),
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

  PopupMenuItem bookmarkCheck(monsterId) {
    if (userProvider.user!.saved_monsters.contains(monsterId)) { //todo null check userProvider.user
      return PopupMenuItem(value: "unsave",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.bookmark)),
            Text("Unsave Monster")
          ]));
    }
    else {
      return PopupMenuItem(value: "save",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.bookmark_border)),
            Text("Save Monster")
          ]));
    }
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
  save(monsterId){
    userProvider.user?.saved_monsters.add(monsterId);
    db.collection("Users").doc("${getUid()}").update({'saved_monsters':FieldValue.arrayUnion([monsterId])});
  }

  unsave(monsterId){
    userProvider.user?.saved_monsters.remove(monsterId);
    db.collection("Users").doc("${getUid()}").update({'saved_monsters':FieldValue.arrayRemove([monsterId])});
  }

/*  void loadmore(){
    setState(() {
      loadedIndex+=20;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadmore();
    }
  }*/

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
    //lastItem = null;
    //setBookmarked();
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    //_scrollController.addListener(_onScroll);
    //setBookmarked();
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<MonsterStore>(
      query: createQuery(),
      pageSize:20,
      emptyBuilder: (context) => const Text('No data'),
      errorBuilder: (context, error, stackTrace) => Text(error.toString()),
      loadingBuilder: (context) => const CircularProgressIndicator(),
      itemBuilder: (context, doc) {
        final monster = doc.data();
        return MonsterSetupBasic(monster.cr!.toDouble(),monster.name!,(){view(doc.id);},popUpBuilder(doc),context);

      },
    );

    /* Size size = MediaQuery
        .of(context)
        .size;

    _controller.addListener(() {
      setState(() {
        search = _controller.text.toString();
      });
    });

    return FutureBuilder<QuerySnapshot>(
        future: createQuery(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong")); //todo Use theme colour
          }

*//*          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(child: Text("No monster data exists"));
          }*//*

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                *//*TextField(
                        controller: _controller, decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.color),
                          suffixIcon: clearIcon(_controller, context)),
                      ),*//*
                body: ListView.builder(
                  controller: _scrollController,
                    itemCount: snapshot.data?.size,
                    itemBuilder: (BuildContext context, int index) {
                    _monsterList.add(snapshot.data!.docs[index]);
                      return MonsterSetupBasic(snapshot.data?.docs[index].get('cr').toDouble(),snapshot.data?.docs[index].get('name'),(){view(snapshot.data?.docs[index].id);},context);
                    }
                ));
          }
          else {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("\n\nLoading",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              ],
            ));
          } //todo use theme colour
        });*/
  }

}