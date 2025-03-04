import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter_svg/flutter_svg.dart';

import '../../services/auth.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    if (loggedIn() == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
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
          color: Colors.black12,
        )
    );
  }
}