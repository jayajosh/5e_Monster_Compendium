import 'package:firebase_storage/firebase_storage.dart';
import '../services/auth.dart';

Future PictureUpload(file) async {
  Reference ref = FirebaseStorage.instance.ref().child("/avatars").child("/${getUid()}");
  try{await ref.delete();await wipePhoto();}
  catch(e){};
  await ref.putFile(file);
}

Future<String> PictureGet() async {
  Reference ref = FirebaseStorage.instance.ref().child("/avatars").child("/${getUid()}");
  return await ref.getDownloadURL();
}