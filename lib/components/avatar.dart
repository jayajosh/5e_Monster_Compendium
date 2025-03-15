import 'package:flutter/material.dart';
import '../services/auth.dart';

Avatar(size,fontSize) {
  String? avatar = getPicture();
  String? username = getUsername();

  return CircleAvatar(
      backgroundImage: (avatar == null) ? null : NetworkImage(avatar),
      backgroundColor: Colors.pink,
      child: (avatar != null) ? null : Text(
        //todo null check it \/\/\/
          username![0].toUpperCase(), style: TextStyle(fontSize: fontSize)),
      radius: size);
}