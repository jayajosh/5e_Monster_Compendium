import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_svg/flutter_svg.dart';

import '../../services/auth.dart';
import '../../services/user_provider.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (loggedIn() == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await userProvider.fetchAndSetUser(FirebaseAuth.instance.currentUser!.uid);
        Navigator.pushNamedAndRemoveUntil(context, "/Home", (routes) => false);
        });
    }
    else {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Navigator.pushNamedAndRemoveUntil(context, "/WelcomePage", (routes) => false);
      });
    }
    return new Scaffold(
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