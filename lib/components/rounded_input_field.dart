import 'package:flutter/material.dart';
import './text_field_container.dart';


class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool isPassword;
  final TextInputType textInputType;
  final TextEditingController controller;
  const RoundedInputField({
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    this.isPassword = false,
    required this.textInputType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        obscureText: isPassword,
        onChanged: onChanged,
        cursorColor: Theme.of(context).textTheme.bodyLarge?.color,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}