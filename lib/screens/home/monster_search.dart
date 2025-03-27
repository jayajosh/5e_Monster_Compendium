import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../components/clearIcon.dart';
import '../../components/item_views.dart';
import '../../components/platform_dialog.dart';
import '../../locator.dart';
import '../../services/auth.dart';
//import 'package:share/share.dart';
import '../../services/active_filters.dart';
import '../../services/monster_storage.dart';
import 'monster_view.dart';
//import '../../services/dynamic_link.dart';

final db = FirebaseFirestore.instance;

final MonsterRef = db.collection('Monsters');

class MonsterSearch extends StatefulWidget {
  const MonsterSearch({Key? key}) : super(key: key);

  @override
  _MonsterSearch createState() => _MonsterSearch();

}

class _MonsterSearch extends State<MonsterSearch> {
  TextEditingController _controller = new TextEditingController(text: "");
  //ScrollController _scrollController = new ScrollController(); //todo check and delete

  int loadedIndex = 0;

  var lastItem;

  String search = "";

  List bookmarked = [];

  createQuery() {
    var monsterQuery = MonsterRef.get();
    locator<ActiveFilters>().getOn() ?
    monsterQuery = MonsterRef
        .where('cr', isGreaterThanOrEqualTo: locator<ActiveFilters>().crmin)
        .where('cr', isLessThanOrEqualTo: locator<ActiveFilters>().crmax)
        .get()
        : monsterQuery = MonsterRef.get();
    return monsterQuery;
  }

  PopUpItems(uid) {
    return [
      PopupMenuItem(value: "view",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.map)),
            Text("View Route")
          ])),
      PopupMenuItem(value: "copy",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.copy)),
            Text("Clone Route")
          ])),
      bookmarkCheck(uid),
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
            Text("Share Route")
          ])),
    ];
  }

  PopupMenuItem bookmarkCheck(uid) {
    if (bookmarked.contains(uid)) {
      return PopupMenuItem(value: "unsave",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.bookmark)),
            Text("Unsave Route")
          ]));
    }
    else {
      return PopupMenuItem(value: "save",
          child: Row(children: [
            Padding(padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.bookmark_border)),
            Text("Save Route")
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
    createQuery();
    Size size = MediaQuery
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

/*          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(child: Text("No monster data exists"));
          }*/

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                /*TextField(
                        controller: _controller, decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.color),
                          suffixIcon: clearIcon(_controller, context)),
                      ),*/
                body: ListView.builder(
                    itemCount: snapshot.data?.size,
                    itemBuilder: (BuildContext context, int index) {
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
        });
  }

}