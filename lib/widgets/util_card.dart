import 'dart:io';

import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../functionality/categories.dart';
import '../functionality/paths.dart';

class RecommendUtilCard extends StatelessWidget {
  const RecommendUtilCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.category,
    required this.percent,
    required this.press,
    required this.done,
    required this.username,
  }) : super(key: key);

  final String imagePath, name, category, percent, username;
  final bool done;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 150,
      child: GestureDetector(
        onTap: press,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(''),
                width: 170,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(imagePath)),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                child: Container(
                  padding: const EdgeInsets.all(kDefaultPadding / 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 50,
                        color: kPrimaryColor.withOpacity(0.23),
                      )
                    ],
                  ),
                  child: Container(
                    width: 150,
                    child: Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$name\n',
                                style: const TextStyle(
                                  color: kTextColor,
                                  fontSize: 6,
                                ),
                              ),
                              TextSpan(
                                text: 'Category: ${category.toUpperCase()}',
                                style: TextStyle(
                                  color: kPrimaryColor.withOpacity(0.5),
                                  fontSize: 5,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        buildFutureBuilder(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: Offset(5, 10),
                blurRadius: 20,
                color: kPrimaryColor.withOpacity(0.3))
          ]),
        ),
      ),
    );
  }

  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder(
      future: readContent(
        formatFileName(imagePath, username),
      ),
      builder: (content, snapshot) {
        final String data = snapshot.data.toString();
        bool nCL = true;
        bool nSH = true;
        if (data.length > 0) {
          if ((data.split('///')[0]).length > 0) {
            nSH = false;
          }
          if (data.split('///').length > 2) {
            if (data.split('///')[2] != classCategoryList[0]) {
              nCL = false;
            }
          }
          /*
          if (data.split('///').length > 3) {
            if (data.split('///')[3] != classCategoryList2[0]) {
              nCL2 = false;
            }
          }
          */
        }

        final double iconSize = 20;
        return Row(
          children: [
            Icon(
              Icons.category_rounded,
              color: nSH ? Colors.grey : Colors.orange,
              size: iconSize,
            ),
            Icon(
              Icons.check_box_outlined,
              color: nCL ? Colors.grey : Colors.green,
              size: iconSize,
            ),
          ],
        );
      },
    );
  }
}
