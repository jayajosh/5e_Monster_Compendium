import 'package:flutter/material.dart';

class ActiveFilters with ChangeNotifier{
  bool on = false;
  DateTime? created;
  double? crmin;
  double? crmax;
  String? size;
  String? type;
  String? alignment;

  bool getOn(){return on;}
  updateFilters(){notifyListeners();}
}


