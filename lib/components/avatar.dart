import 'package:flutter/material.dart';
import '../services/auth.dart';

avatar(size,fontSize) {
  String? avatar = getPicture();
  String? username = getUsername();

  return CircleAvatar(
      backgroundImage: (avatar == null) ? null : NetworkImage(avatar),
      backgroundColor: Colors.pink,
      radius: size,
      child: (avatar != null) ? null : Text(
        //todo null check it \/\/\/
          username![0].toUpperCase(), style: TextStyle(fontSize: fontSize)),
      );
}