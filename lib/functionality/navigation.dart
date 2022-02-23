import 'package:flutter/material.dart';
import '../core/constants.dart';

class CustomNavigationAppBarViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Segment and Classify',
      style: TextStyle(color: kBackgroundColor),
    );
  }
}

class CustomNavigationAppBarScrollPage extends StatelessWidget {
  final String username;
  const CustomNavigationAppBarScrollPage({Key? key, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String locUsername = username;
    double fontSize = 14;

    if (locUsername.length > 7) {
      fontSize = 12;
    }

    if (locUsername.length > 10) {
      fontSize = 10;
    }

    if (locUsername.length > 12) {
      locUsername = locUsername.substring(0, 12) + '...';
      fontSize = 8;
    }

    return Row(
      children: [
        Text(
          'Hello $locUsername!',
          style: TextStyle(fontSize: fontSize),
        ),
        Spacer(),
        Text(
          'Select Image to start editing',
          style: TextStyle(fontSize: fontSize),
        ),
        Spacer(),
      ],
    );
  }
}
