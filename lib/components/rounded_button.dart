import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function() press;
  const RoundedButton({
    required this.text,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
          width: size.width*0.8,
          height: size.height*0.065,
          child: ElevatedButton(
            onPressed: press,
            child: Text(
              text,
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
            ),style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          ),
        );
  }
}