import 'package:flutter/material.dart';
import 'package:monster_compendium/screens/home/monster_search.dart';
import 'package:monster_compendium/screens/home/edit_list.dart';
import '../components/avatar.dart';
import '../components/drawer_constructors/bookmark_drawer_setup.dart';
import '../components/center_button_nav.dart';
import '../components/drawer_constructors/profile_drawer_setup.dart';
import '../components/search_filters.dart';
import '../services/generate_statblock.dart';

class Home extends StatefulWidget {
  Home({int? currentIndex});

  _Home createState() => _Home();
}

class _Home extends State<Home>{
  late List<Widget> _page = [
    MonsterSearch(key: monsterSearchKey),
    EditList(),
    Center(),
    Center(child: Text('Coming Soon')),
    Center(child: StatblockGenerator()),
  ];
  GlobalKey<State<MonsterSearch>> monsterSearchKey = new GlobalKey<State<MonsterSearch>>();


  int currentIndex = 0;
  void onTapped(int index) {
    setState(() {
      //if (index==4){qrScan(context); index = currentIndex;}
      currentIndex = index;
    });
  }

  GlobalKey<ScaffoldState> mainScaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      key: mainScaffold,
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {  },), //todo disable on other pages
          IconButton(icon: Icon(Icons.filter_alt), onPressed: ()  async {
            await filterList(context);
            monsterSearchKey.currentState?.setState(() {}); //todo check this is good practise, updates page when filters list closes
            },), //todo disable on other pages + fill/unfill for filters (maybe 'custom' widget)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              child: avatar(15.0,15.0),
              onTap: () {mainScaffold.currentState?.openEndDrawer();},
            ),
          )],
        //padding: const EdgeInsets.symmetric(horizontal: 10.0),
        /*leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [InkWell(
              child: Icon(Icons.menu),
              onTap: () {mainScaffold.currentState?.openDrawer();},
            ),
              InkWell(
                child: Avatar(15.0,15.0),
                onTap: () {mainScaffold.currentState?.openEndDrawer();},
              ),
            ]
        ),*/
      ),
      body:
      Stack(
          children: [/*Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/parchment_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),*/
            Stack(children: [
              IndexedStack(
                index: currentIndex,
                children: _page,
              ),
              // todo move to right, add a different drawer for bookmarked monsters left?
            ]),
          ]
      ),
      drawer: BookmarkDrawerSetup(),
      endDrawer: ProfileDrawerSetup(),
      bottomNavigationBar: BottomAppBar( //todo refactor to be just bottom app bar with custom button widgets
        height: 56,
        shape: CircularNotchedRectangle(),
        notchMargin: 16,
        child: Wrap(
          children: [
            BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: [BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: 'Edit',
              ),
              BottomNavigationBarItem(
                icon: Icon(null),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Encounter',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome),
                label: 'Generate',
              ),
            ],
                  /*          showUnselectedLabels: false,
            showSelectedLabels: false,*/
            currentIndex: currentIndex,
            onTap: onTapped,
          ),
        ]
        ),
      ),
      floatingActionButton: CenterButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );

  }
}