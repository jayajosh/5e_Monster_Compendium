import 'package:flutter/material.dart';
import 'package:monster_compendium/screens/home/monster_search.dart';
import '../Screens/Welcome/login_page.dart';
import '../Screens/Welcome/sign_up_page.dart';
import '../components/avatar.dart';
import '../components/bookmark_drawer_setup.dart';
import '../components/center_button_nav.dart';
import '../components/profile_drawer_setup.dart';
import '../components/search_filters.dart';
import '/services/auth.dart';

import '../components/rounded_button.dart';

class Home extends StatefulWidget {
  Home({int? currentIndex});

  final List<Widget> _page = [
    MonsterSearch(),
    Center(child:RoundedButton(text: "SignOut1", press: () {})),
    Center(child:RoundedButton(text: "SignOut3", press: () {})),
    LoginPage(),
    SignUpPage()
  ];

  _Home createState() => _Home();
}

class _Home extends State<Home>{
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
          IconButton(icon: Icon(Icons.filter_alt), onPressed: () { FilterList(context); },), //todo disable on other pages + fill/unfill for filters (maybe 'custom' widget)
          Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
            child: Avatar(15.0,15.0),
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
          children: [Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/parchment_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
            Stack(children: [
              IndexedStack(
                index: currentIndex,
                children: widget._page,
              ),
              // todo move to right, add a different drawer for bookmarked monsters left?
            ]),
          ]
      ),
      drawer: BookmarkDrawerSetup(),
      endDrawer: ProfileDrawerSetup(),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Wrap( children:[
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(null),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: 'Edit',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner),
                label: 'QR Scanner',
              ),
            ],
/*          showUnselectedLabels: false,
            showSelectedLabels: false,*/
            currentIndex: currentIndex,
            onTap: onTapped,
          )
        ]
        ),
      ),
      floatingActionButton: CenterButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );

  }
}