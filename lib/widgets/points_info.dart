import 'package:flutter/material.dart';
import '../core/constants.dart';

class PointsInfo extends StatelessWidget {
  final List<Offset> points;

  const PointsInfo({
    Key key,
    this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int lenList = points.length;
    return lenList > 0 ? buildFull(context) : buildEmpty(context);
  }

  Widget buildFull(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              formatPoints(points),
              style: TextStyle(fontSize: 4),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimaryColor.withOpacity(0.22),
            boxShadow: [
              BoxShadow(
                offset: Offset(10, 10),
                blurRadius: 10,
                color: kPrimaryColor.withOpacity(0.1),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmpty(BuildContext context) {
    return Center(child: Icon(Icons.file_present));
  }
}

String formatPoints(List<Offset> points) {
  return points
      .map(
        (offset) {
          if (offset != null) {
            return '${offset.dx};${offset.dy}';
          }
          return '';
        },
      )
      .toList()
      .toString()
      .replaceAll('[', '')
      .replaceAll(']', '')
      .replaceAll(',', '/')
      .replaceAll(';', ',')
      .replaceAll('/', ';');
}

List<Offset> redoPoints(List<Offset> points) {
  // process trough all points from the until you meet the "null" and remove everything until there
  int newMaxint = 0;
  for (int i = points.length - 2; i > 0; i--) {
    if (points[i] == null) {
      newMaxint = i;
      i = 0;
    }
  }
  return points.sublist(0, newMaxint);
}

List<Offset> getPointsFromData(String data) {
  return data.split(';').map((xy) {
    List<String> sublist = xy.split(',');
    if (sublist.length == 2) {
      return Offset(
        double.parse(sublist[0]),
        double.parse(sublist[1]),
      );
    }
  }).toList();
}
