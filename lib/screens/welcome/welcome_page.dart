import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

import '../../components/rounded_button.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({key}) : super(key: key);
  @override
  _WelcomePageState createState() => new _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/parchment_background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                  alignment: FractionalOffset(0.5, 0.3),
                  child:
                  Text(
                    "Route Planner",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: const Color(0xFF404040),
                      fontWeight: FontWeight.w400,
                    ),
                  )
              ),
              Container(
                  alignment: FractionalOffset(0.5, 0.5),
                  child:
                  RoundedButton(text: "LOGIN", press: () {Navigator.pushNamed(context, "/LoginPage");})
              ),
              Container(
                  alignment: FractionalOffset(0.5, 0.6),
                  child:
                  RoundedButton(text: "SIGN UP", press: () {Navigator.pushNamed(context, "/SignUpPage");})
              ),



              /*Stack(
                  children:[
                    Container(
                        alignment: FractionalOffset(0.2, 0.75),
                        child:
                        SocialButton(color: Colors.white,icon: "google")
                    ),
                    Container(
                        alignment: FractionalOffset(0.5, 0.75),
                        child:
                        SocialButton(color: Colors.white,icon: "facebook")
                    ),
                    Container(
                        alignment: FractionalOffset(0.8, 0.75),
                        child:
                        SocialButton(color: Colors.white,icon: "apple")
                    ),
                  ]
              )*/
            ]
        )
    );
  }
}