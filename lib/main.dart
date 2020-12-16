import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'pages/login_page.dart';

void main() => runApp(AppWidget());

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // control the statusbar -> overlap04
    // build the App
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Segment the Images',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
      ),
      home: LoginWithName(),
    );
  }
}
