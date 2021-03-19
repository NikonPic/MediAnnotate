import 'package:fastseg/core/constants.dart';
import 'package:flutter/material.dart';

class MyDropDownButton extends StatelessWidget {
  const MyDropDownButton({
    Key? key,
    required this.doIt,
    required this.locValue,
    required this.locList,
  }) : super(key: key);

  final Function doIt;
  final String locValue;
  final List<String> locList;

  @override
  Widget build(BuildContext context) {
    Color locColor = locValue == locList[0] ? Colors.grey : kSecondaryColor;
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: locColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: DropdownButton<String>(
              underline: Container(
                height: 1,
                color: locColor,
              ),
              value: locValue,
              icon: Icon(
                Icons.arrow_circle_down,
                color: locColor,
              ),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(fontWeight: FontWeight.bold),
              onChanged: (String? newValue) {
                doIt(newValue);
              },
              items: locList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: locColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
