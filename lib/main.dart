import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vcard_manager/LoadingScreen.dart';
import 'package:vcard_manager/constants.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V-Card Manager',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        primaryColorLight: kPrimaryLightColor,
        primaryColorDark: kPrimaryDarkColor,
        accentColor: kSecondaryColor,
        canvasColor: kPrimaryDarkColor,
        dividerColor: kSecondaryLightColor,
        focusColor: kSecondaryColor,
        buttonColor: kSecondaryColor,
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Hind',
            color: Color(0xffffffff),
          ),
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => LoadingScreen(),
      },
    );
  }
}
