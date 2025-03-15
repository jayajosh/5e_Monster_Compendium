import 'package:flutter/material.dart';

Widget MonsterSetupBasic(int cr, String name, GestureTapCallback onTap, BuildContext context) {
  return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery
          .of(context)
          .size
          .width * 0.1),
      leading: Text('CR\n' + cr.toString(),textAlign: TextAlign.center),
      title: Text(name),
      trailing: Icon(Icons.more_vert),
      onTap: onTap
  );
}