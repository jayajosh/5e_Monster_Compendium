import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monster_compendium/screens/home/monster%20creation/add_monster.dart';
import 'package:monster_compendium/screens/home/monster%20creation/edit_monster.dart';
import 'package:provider/provider.dart';
import 'Screens/Welcome/sign_up_page.dart';
import 'locator.dart';
import 'screens/Welcome/splash.dart';
import 'screens/Home/monster_view.dart';
import 'screens/home.dart';
import 'services/navigation.dart';
import 'Screens/Welcome/login_page.dart';
import 'Screens/Welcome/welcome_page.dart';
import 'services/themes.dart';

main() {
  setUpLocator();

  WidgetsFlutterBinding.ensureInitialized();
  return runApp(ChangeNotifierProvider<ThemeNotifier>(create: (_) => new ThemeNotifier(),child: Main()));

}

class Main extends StatefulWidget {
  @override
  _Main createState() => _Main();
}

class _Main extends State<Main> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //handleLinks();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //handleLinks();
    }
  }

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
          navigatorKey: locator<Navigation>().navigationKey,
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: theme.getThemeMode(),
          home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot){
              /*handleStartUpLogic(context);*/
              //handleLinks();
              if (snapshot.hasError) {
                print ('An error has occured ${snapshot.error.toString()}');
                return Text('Something went wrong!');
              } else if (snapshot.hasData) {
                return Splash();
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),

          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/Home': (context) => Home(),
            '/Splash': (context) => Splash(),
            '/WelcomePage': (context) => WelcomePage(),
            '/LoginPage': (context) => LoginPage(),
            '/SignUpPage': (context) => SignUpPage(),
            '/Home/MonsterView': (context) => MonsterView(),
            '/Home/AddMonster': (context) => AddMonster(),
            '/Home/EditMonster': (context) => EditMonster(),
            '/Home/MonsterView/EditMonster': (context) => EditMonster(),
          },
        )


    );
  }

}

/*
Future handleStartUpLogic(context) async {
*/
/*  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService =
  locator<PushNotificationService>();*//*



  await _dynamicLinkService.handleDynamicLinks(context);

*/
/*  // Register for push notifications
  await _pushNotificationService.initialise();*//*

}*/

