import 'package:flutter/material.dart';

Future FilterList(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {return SizedBox (height: 400, child: Center(child:ElevatedButton(onPressed: () {Navigator.pop(context);}, child: const Text('Close BottomSheet'),)) ); },
  );
}