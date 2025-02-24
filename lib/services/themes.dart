import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <SharedPreferences> _prefs = SharedPreferences.getInstance();

class ThemeNotifier with ChangeNotifier {

  ThemeMode _themeMode= ThemeMode.system;
  ThemeMode getThemeMode() {return _themeMode;}

  final darkTheme = ThemeData(
      primarySwatch: Colors.lightBlue,
      primaryColor: Colors.lightBlueAccent,
      //accentColor: Colors.blue,

      scaffoldBackgroundColor: Color(0xff121212),
      //backgroundColor: Color(0xff363636),

      textTheme: TextTheme(bodyLarge: TextStyle(
          color: Color(0xffc7d0d7)),
      bodyMedium: TextStyle(color: Color(0xffcdcdcd))),

      indicatorColor: Colors.lightBlueAccent,
      //buttonColor: Colors.lightBlueAccent,

      hintColor:Color(0xCCc7d0d7),
      dividerColor: Colors.black12,

      highlightColor:Color(0xaac7d0d7),
      hoverColor:Color(0xaac7d0d7),

      focusColor: Colors.lightBlueAccent,

      disabledColor: Colors.grey,
      //cardColor: isDarkTheme ? Color(0xaa404040) : Color(0xaaF1F5FB),
      brightness:Brightness.dark
    /*buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),*/
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
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
    /*buttonTheme: Theme.of(context).buttonTheme.copyWith(
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
