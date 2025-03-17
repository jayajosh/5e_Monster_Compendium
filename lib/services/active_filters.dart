import 'package:flutter/material.dart';

class ActiveFilters with ChangeNotifier{
  bool on = false;
  DateTime? created;
  double? cr;
  String? size;
  String? habitat;

  getFilters() async {}
  bool getOn(){return on;}
  updateFilters(){notifyListeners();}
}


