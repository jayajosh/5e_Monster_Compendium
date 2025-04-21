import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/themes.dart';

class PhotoBorder extends StatelessWidget {//todo resize images to save ram (flutter inspector to see this)
  final String? url;
  PhotoBorder({required this.url});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImage(url),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //todo swap to shimmer
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print('Error loading image: ${snapshot.error}'); //todo log it
            return const Text('Error loading image'); //todo swap to error image or placeholder
          } else {
            return Consumer<ThemeNotifier>(
              builder: (context, theme, _) {
                bool isDarkMode = theme.getThemeMode() == ThemeMode.dark;
                if (!isDarkMode) {
                  return lightModeBorder(snapshot.data);
                } else {
                  return darkModeBorder(snapshot.data);
                }
              },
            );
          }
        }
    );
  }
}

getImage (url) async{
  var image = Image(image:NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),fit: BoxFit.fill);
  if(url != null){
    final ref = FirebaseStorage.instance.ref().child(url);
    final downloadUrl = await ref.getDownloadURL();
    image = Image(image:NetworkImage(downloadUrl),fit: BoxFit.fill);
  }
  return image;
}

Widget lightModeBorder(image) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8,8,0,8),
    child: Container(
      padding: EdgeInsets.all(16),
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/frame_border_light.png'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: image,
    ),
  );
}

Widget darkModeBorder(image) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8,8,0,8),
    child: Container(
      padding: EdgeInsets.all(16),
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/frame_border_dark.png'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: image,
    ),
  );
}