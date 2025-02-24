import 'package:flutter/material.dart';

class Navigation{
  GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static Navigation instance = Navigation();

  Navigation(){
    navigationKey = GlobalKey<NavigatorState>();
  }

}