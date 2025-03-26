import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <SharedPreferences> _prefs = SharedPreferences.getInstance();

class ThemeNotifier with ChangeNotifier {

  ThemeMode _themeMode= ThemeMode.system;
  ThemeMode getThemeMode() {return _themeMode;}

  final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFA30D0D), // Deep Red
      onPrimary: Colors.white,
      secondary: Color(0xFFC9A643), // Gold
      onSecondary: Colors.black,
      surface: Color(0xFF1E1F22),
      //onSurface: Color(0xFFFFFF),// Dark
      surfaceContainerLow: Color(0xFF2E3640), // Dark
      error: Color(0xFF7C0A02), // Blood Red
      onError: Colors.white,
    ),
  );

  final lightTheme = ThemeData(
    //brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFFA30D0D), // Deep Red
      onPrimary: Colors.white,
      secondary: Color(0xFFC9A643), // Gold
      onSecondary: Colors.black,
      surface: Color(0xFFF5E8C7), // Parchment
      surfaceContainerLow: Color(0xFFE0D8CC), // Light gray for cards
      onSurface: Color(0xFF1E1E1E), // Dark text
      error: Color(0xFF7C0A02), // Blood Red
      onError: Colors.white,
    ),
    //primaryColor: Colors.black,
    /*primaryColor: Colors.blue,
    //accentColor: Colors.lightBlueAccent,

    scaffoldBackgroundColor: Color(0xffF4F4F4),
    //backgroundColor: Color(0xffb4b4b4),

    textTheme: TextTheme(bodyLarge: TextStyle(
        color: Color(0xff121212)),
        bodyMedium: TextStyle(color: Color(0xffffffff))),

    indicatorColor: Colors.blue,
    //buttonColor: Colors.blue,

    hintColor: Color(0xCC494949),
    dividerColor: Colors.black87,

    highlightColor: Color(0xaa494949),
    hoverColor: Color(0xaa494949),

    focusColor: Colors.blue,

    disabledColor: Colors.grey,
    //cardColor: isDarkTheme ? Color(0xaa404040) : Color(0xaaF1F5FB),
    brightness: Brightness.light,
    *//*buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),*/
  );

  ThemeNotifier() {
    getThemePrefs().then((value) {
      if (value == false) {_themeMode = ThemeMode.light;}
      else if (value == true) {_themeMode = ThemeMode.dark;}
      else{_themeMode = ThemeMode.system;}
      notifyListeners();}
      );}



  getThemePrefs() async {
    return await _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('Theme');
    });
  }

  void setSystemTheme() async {
    final prefs = await _prefs;
    prefs.remove("Theme");
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  void setDarkTheme() async {
    final prefs = await _prefs;
    prefs.setBool("Theme", true);
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void setLightTheme() async {
    final prefs = await _prefs;
    prefs.setBool("Theme", false);
    _themeMode = ThemeMode.light;
    notifyListeners();
  }
}

TextStyle TitleFont() {
  return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
      shadows: [
  Shadow(
  color: Colors.black.withOpacity(0.2),
  blurRadius: 3,
  offset: Offset(1, 1),
  )]);
  }