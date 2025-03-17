import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';
//import 'services/picture_selector.dart';
//import 'services/picture_storage.dart';
import '../services/themes.dart';
import 'package:url_launcher/url_launcher.dart';


class BookmarkDrawerSetup extends StatefulWidget {
  @override
  _BookmarkDrawerSetupState createState() => new _BookmarkDrawerSetupState();
}

class _BookmarkDrawerSetupState extends State<BookmarkDrawerSetup> {

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


  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          padding: EdgeInsets.zero,
          child: CustomScrollView( ///Allows for landscape to scroll
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(children: [
                    HeaderSetup(),
                    ItemSetup(Icons.person, "Profile", () {Navigator.pushNamed(context, '/Home/Profile',arguments: getUid());}),
                    ItemSetup(Icons.bookmark, "Saved Routes", () {Navigator.pushNamed(context, '/Home/SavedRoutes');}),
                    /*async {
                File img = await getAvatarImage();
                await PictureUpload(img);
                await setPicture(img);
                setState(() {avatar = getPicture();});
              }),*/
                    ///Unimplemented Follower Display - For future improvement.
                    /*ItemSetup(Icons.history, "Recent Routes", () {}),
                    ItemSetup(Icons.qr_code, "QR Codes", () {Navigator.pushNamed(context, '/Home/RouteEditor/RouteAdd');}),*/
                    Expanded(child:
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Divider(thickness: 1),
                          ),
                          ItemSetup(Icons.bug_report, "Report an issue", () {reportBug();}),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Divider(thickness: 1),
                          ),
                          Row(
                            children: [
                              Expanded(child: ItemSetup(Icons.logout, "Log Out", () {
                                logout(context);
                              })),
                              Container(child: PopupMenuButton(
                                  icon: Icon(Icons.nightlight_round),
                                  itemBuilder: (context) {return darkModeOptions();},onSelected: (value){
                                final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
                                if (value == "dark") {themeNotifier.setDarkTheme();}
                                else if (value == "light") {themeNotifier.setLightTheme();}
                                else {themeNotifier.setSystemTheme();}
                              }
                              )
                              )
                            ],
                          ),
                        ],
                      ),
                    ),)
                  ]),
                )
              ]),
        ));
  }
}

darkModeOptions() {
  return [
    PopupMenuItem(value: "system",child: Row(children: [Padding(padding: const EdgeInsets.only(right:10.0), child: Icon(Icons.autorenew)),Text("System")])),
    PopupMenuItem(value: "dark",child: Row(children: [Padding(padding: const EdgeInsets.only(right:10.0), child: Icon(Icons.nightlight_round)),Text("Dark Mode")])),
    PopupMenuItem(value: "light",child: Row(children: [Padding(padding: const EdgeInsets.only(right:10.0), child: Icon(Icons.wb_sunny)),Text("Light Mode")]))
  ];
}

void reportBug() async {
  final Uri _uri = Uri(
    scheme: 'mailto',
    path: 'j.aston-adams@hotmail.co.uk',
    query: 'subject=Bug%20Report Feedback&body=Platform:%20${Platform.operatingSystem}',
  );
  // final _uri = Uri.parse("mailto:j.aston-adams@hotmail.co.uk?subject=Bug%20Report&body=Platform:%20${Platform.operatingSystem}");
    await canLaunchUrl(_uri) ? await launchUrl(_uri)
      : print( 'Could not launch $_uri'); //todo replace with logcat
}