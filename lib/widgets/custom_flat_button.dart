import 'package:flutter/material.dart';
import '../core/constants.dart';

class TitleWithCustomButton extends StatelessWidget {
  const TitleWithCustomButton({
    Key key,
    this.press,
    this.buttonName,
  }) : super(key: key);

  final VoidCallback press;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: kPrimaryColor.withOpacity(0.8),
        onPressed: press,
        child: Text(
          buttonName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(5, 10),
            color: kPrimaryColor.withOpacity(0.05),
          )
        ],
      ),
    );
  }
}
