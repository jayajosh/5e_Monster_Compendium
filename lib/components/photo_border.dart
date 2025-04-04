import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/themes.dart';

Widget photoBorder(image) {
  return Consumer<ThemeNotifier>(
    builder: (context, theme, _) {
      bool isDarkMode = theme.getThemeMode() == ThemeMode.dark;
      if (!isDarkMode) {
        return lightModeBorder(image);
      } else {
        return darkModeBorder(image);
      }
    },
  );
}

Widget lightModeBorder(image) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8,8,0,8),
    child: Container(
      padding: EdgeInsets.all(16), // padding inside the container
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/frame_border_light.png'), // Your border image
          fit: BoxFit.fill, // Or BoxFit.cover for different effects
        ),
        borderRadius: BorderRadius.circular(10), // Rounded corners if needed
      ),
      child: image, // Your content
    ),
  );
}

Widget darkModeBorder(image) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8,8,0,8),
    child: Container(
      padding: EdgeInsets.all(16), // padding inside the container
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/frame_border_dark.png'), // Your border image
          fit: BoxFit.fill, // Or BoxFit.cover for different effects
        ),
        borderRadius: BorderRadius.circular(10), // Rounded corners if needed
      ),
      child: image, // Your content
    ),
  );
}