import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final storage = FirebaseStorage.instance;
final storageRef = storage.ref();
late Reference storageChild;

storeChild(id,image,context) async {
  storageChild = storageRef.child('/Monsters/Images/$id.png');
  try{await storageChild.putFile(image);}
  catch (e) {ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error uploading image: $e'),
      duration: const Duration(seconds: 5),
    ),
  );}
  return storageChild.fullPath;
}

Future<File?> pickImage(context) async { //todo give android permission
  File? _imageFile;
  final picker = ImagePicker();

  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error picking image: $e'),
        duration: const Duration(seconds: 5),
      ),
    );
  }
  return _imageFile;

}

//todo convert to this if needed for security?? //final storage = FirebaseStorage.instanceFor(app: customApp);