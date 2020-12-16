import 'package:flutter/material.dart';
import '../core/constants.dart';

class CustomNavigationAppBarViewPage extends StatelessWidget {
  const CustomNavigationAppBarViewPage({
    Key key,
    this.func,
  }) : super(key: key);
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Segment and Classify',
      style: TextStyle(color: kBackgroundColor),
    );
  }
}

class CustomNavigationAppBarScrollPage extends StatelessWidget {
  const CustomNavigationAppBarScrollPage({
    Key key,
    this.func,
  }) : super(key: key);
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Select Image',
      style: TextStyle(color: kBackgroundColor),
    );
  }
}
