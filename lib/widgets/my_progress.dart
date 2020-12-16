import 'package:flutter/material.dart';
import '../core/constants.dart';

class MyProgressIndicator extends StatelessWidget {
  const MyProgressIndicator({
    Key key,
    @required int count,
    @required int lenList,
  })  : _count = count,
        _lenList = lenList,
        super(key: key);

  final int _count;
  final int _lenList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        child: LinearProgressIndicator(
          value: _count / _lenList,
          minHeight: 20,
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          backgroundColor: Colors.blue[50],
        ),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: Offset(10, 10),
            color: kPrimaryColor.withOpacity(0.22),
          )
        ]),
      ),
    );
  }
}
