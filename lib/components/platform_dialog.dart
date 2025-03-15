import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../services/auth.dart';
//import 'package:firebase_database/firebase_database.dart';
/*
DialogInput(context,String _title, [String _page]) {
  TextEditingController _textFieldController = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      bool isValid = false;

      if (Platform.isAndroid) {
        return AlertDialog(
          title: Text(_title),
          content: TextField(
            onChanged: (value) {},
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Route Name"),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
                child: Text('Confirm'),
                onPressed: () {
                  _textFieldController.text.length < 4
                      ? errorSnack(context)
                      : pressed(context, _page, _textFieldController);
                }
              //Navigator.of(context).pop();
            )
          ],
        );
      }

      else{
        return CupertinoAlertDialog(
          title: Text(_title),
          content: TextField(
            onChanged: (value) {},
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Route Name"),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
                child: Text('Confirm'),
                onPressed: () {
                  _textFieldController.text.length < 4
                      ? errorSnack(context)
                      : pressed(context, _page, _textFieldController);
                }
              //Navigator.of(context).pop();
            )
          ],
        );
      }
    },
  );
}

DialogWarning(context,_page,_textFieldController){
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        bool isValid = false;
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text("Name already exists"),
            content: Text("You already have a route with this name."),
            actions: <Widget>[
              TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
              TextButton(
                  child: Text('Edit'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    advance(context, _page, _textFieldController, null);
                  }
                //Navigator.of(context).pop();
              ),
              TextButton(
                  child: Text('Overwrite'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    advance(context, _page, _textFieldController, true);
                  }
                //Navigator.of(context).pop();
              )
            ],
          );
        }
        else{
          return CupertinoAlertDialog(
            title: Text("Name already exists"),
            content: Text("You already have a route with this name."),
            actions: <Widget>[
              TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
              TextButton(
                  child: Text('Edit'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    advance(context, _page, _textFieldController, null);
                  }
                //Navigator.of(context).pop();
              ),
              TextButton(
                  child: Text('Overwrite'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    advance(context, _page, _textFieldController, true);
                  }
                //Navigator.of(context).pop();
              )
            ],
          );
        }
      });
}

pressed(context, _page, _textFieldController) async{
  Navigator.of(context).pop();
  if (_page != null) {
    bool match = await checkname( _textFieldController.text.toString());
    if (match == true) {DialogWarning(context,_page,_textFieldController);}
    else{advance(context,_page,_textFieldController,null);}
  }}


errorSnack(context){
  FocusScope.of(context).unfocus();
  final snack = SnackBar(content: Text('Route Name must be 4 or more characters'), behavior: SnackBarBehavior.floating );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}

Future<bool> checkname(routename) async {
  final uid = getUid();
  bool match = false;

  await FirebaseDatabase.instance.reference().child("Routes").orderByChild("uid").equalTo(uid).once().then((snapshot) {
    final map = Map<dynamic, dynamic>.from(snapshot.value);
    map.forEach((key, value) {
      if (routename == value["routename"]){match = true;}
    });

  });

  return match;
}

advance(context,_page,_textFieldController,overwrite) async {
  String routename = _textFieldController.text.toString();
  if (overwrite == true) {await overwriteRoute(routename);}
  Navigator.pushNamed(context, _page,
      arguments: routename);
}

overwriteRoute(routename) async {
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child(
      "Routes").child("${getUid()}-${routename}");

  await dbRef.set({
    "routename": routename,
    "uid": getUid(),
    "username": getUsername().toString(),
    "rating": 0,
    "nrating": 0,
    "city": "Get users city",
  });
  await dbRef.child("route").set([]);
}
*/
resetPassword(context){
  TextEditingController _textFieldController = TextEditingController();
  final _title = "Reset Password";

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      bool isValid = false;

      if (Platform.isAndroid) {
        return AlertDialog(
          title: Text(_title),
          content: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {},
            controller: _textFieldController,
            decoration: passwordDecoration(),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
                child: Text('Confirm'),
                onPressed: () async {
                  _textFieldController.text.length < 1
                      ? errorPassword(context) : await resetPass(_textFieldController.text); resetSent(context,_textFieldController.text); Navigator.of(context).pop();
                }
            )
          ],
        );
      }

      else{
        return CupertinoAlertDialog(
          title: Text(_title),
          content: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {},
            controller: _textFieldController,
            decoration: passwordDecoration(),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
                child: Text('Confirm'),
                onPressed: () async { _textFieldController.text.length < 1
                    ? errorPassword(context) : await resetPass(_textFieldController.text); resetSent(context,_textFieldController.text); Navigator.of(context).pop();
                }
            )
          ],
        );
      }
    },
  );
}

errorPassword(context){
  FocusScope.of(context).unfocus();
  final snack = SnackBar(content: Text('Please the email to the account you want to reset'), behavior: SnackBarBehavior.floating );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}

resetSent(context,email){
  FocusScope.of(context).unfocus();
  final snack = SnackBar(content: Text('Password reset sent to $email'), behavior: SnackBarBehavior.floating );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}

passwordDecoration(){
  return InputDecoration(
    icon: Icon(Icons.email),
    hintText: "Email",
  );
}
/*
qrDialog(context,routename,qr){
  Key globalKey = new GlobalKey();
  TextEditingController _textFieldController = TextEditingController();
  final _title = routename;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {

      if (Platform.isAndroid) {
        return AlertDialog(
          //title: Text(_title),
          content: RepaintBoundary(
              key: globalKey,
              child: Container(child:Column(children: [Text(_title),qr], mainAxisSize: MainAxisSize.min),color: Colors.white)
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
                child: Text('Save'),
                onPressed: () async {qrSave(globalKey,routename);}
            )
          ],
        );
      }

      else{
        return CupertinoAlertDialog(
          //title: Text(_title),
          content: RepaintBoundary(
              key: globalKey,
              child: Container(child:Column(children: [Text(_title),qr], mainAxisSize: MainAxisSize.min),color: Colors.white)
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
                child: Text('Save'),
                onPressed: () async {qrSave(globalKey,routename);}
            )
          ],
        );
      }
    },
  );
}

qrSave(gk,routename) async {

  RenderRepaintBoundary boundary = gk.currentContext.findRenderObject();
  var image = await boundary.toImage();
  ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
  Uint8List pngBytes = byteData.buffer.asUint8List();

  final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(pngBytes),
      name: routename);
  print(result);*/

  /*final result = await ImageGallerySaver.saveImage(
      pngBytes,
      quality: 60,
      name: routename);
  print(result);
}*/


/*
Future<void> _captureAndSharePng() async {
  try {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/image.png').create();
    await file.writeAsBytes(pngBytes);

    final channel = const MethodChannel('channel:me.alfian.share/share');
    channel.invokeMethod('shareFile', 'image.png');

  } catch(e) {
    print(e.toString());
  }
}
*/

snackMessage(context,msg){
  FocusScope.of(context).unfocus();
  final snack = SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}