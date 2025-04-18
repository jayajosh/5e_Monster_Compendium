import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:monster_compendium/services/user_factory.dart';
//import 'package:flutter_svg/flutter_svg.dart';

import '../../services/auth.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final isLoggedIn = await loggedIn();
    if (isLoggedIn) {
      final user = await loadUser();
      UserStore _userStore = UserStore.fromMap(user);
      SchedulerBinding.instance.addPostFrameCallback((_) { // added SchedulerBinding here
        Navigator.pushNamedAndRemoveUntil(context, "/Home", (route) => false);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) { // added SchedulerBinding here
        Navigator.pushNamedAndRemoveUntil(context, "/WelcomePage", (route) => false);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/parchment_background.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
    );
  }
}