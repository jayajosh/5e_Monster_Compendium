import 'package:flutter/material.dart';

Widget photoBorder(image) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8,8,0,8),
    child: Container(
      padding: EdgeInsets.all(16), // padding inside the container
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/frame_border.png'), // Your border image
          fit: BoxFit.fill, // Or BoxFit.cover for different effects
        ),
        borderRadius: BorderRadius.circular(10), // Rounded corners if needed
      ),
      child: image, // Your content
    ),
  );
}