import 'package:flutter/material.dart';
import '../core/constants.dart';

class TitleWithCustomButton extends StatelessWidget {
  const TitleWithCustomButton({
    Key? key,
    required this.press,
    required this.buttonName,
  }) : super(key: key);

  final VoidCallback press;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: kPrimaryColor.withOpacity(0.6),
          minimumSize: Size(88, 36),
          padding: EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
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
