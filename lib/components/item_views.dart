import 'package:flutter/material.dart';

Widget MonsterSetupBasic(double cr, String name, GestureTapCallback onTap, Widget? trailing, BuildContext context) {
  String crText;
  cr==0 ? crText = "0" : cr>=1 ? crText = cr.truncate().toString() : crText = "1/"+(1/cr).truncate().toString();

  return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery
          .of(context)
          .size
          .width * 0.1),
      leading: Text('CR\n' + crText,textAlign: TextAlign.center),
      title: Text(name),
      trailing: trailing,
      onTap: onTap
  );
}

Widget MonsterSetupBookmarks(double cr, String name, GestureTapCallback onTap, Widget? trailing, BuildContext context) { //todo just use setupBasic instead?
  String crText;
  cr==0 ? crText = "0" : cr>=1 ? crText = cr.truncate().toString() : crText = "1/"+(1/cr).truncate().toString();

  return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery
          .of(context)
          .size
          .width * 0.1),
      leading: Text('CR\n' + crText,textAlign: TextAlign.center),
      title: Text(name),
      trailing: trailing,
      onTap: onTap
  );
}