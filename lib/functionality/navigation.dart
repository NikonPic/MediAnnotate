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
    if (locUsername.length > 24) {
      locUsername = locUsername.substring(0, 24) + '...';
    }

    return Row(
      children: [
        Text(
          'Hello $locUsername!',
        ),
        Spacer(),
        Text(
          'Select Image to start editing',
          style: TextStyle(fontSize: 12),
        ),
        Spacer(),
      ],
    );
  }
}
