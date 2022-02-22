import 'package:fastseg/core/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 8,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({Key? key, required this.value1, required this.value2})
      : super(key: key);
  final String title = 'PieChart';
  final double value1;
  final double value2;

  @override
  State<StatefulWidget> createState() => PieChart2State(value1, value2);
}

class PieChart2State extends State {
  int touchedIndex = -1;
  final double value1;
  final double value2;

  PieChart2State(this.value1, this.value2);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Expanded(
        child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
                pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 10,
                sections: showingSections()),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 14.0 : 12.0;
      final radius = isTouched ? 20.0 : 12.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
              color: kPrimaryColor.withOpacity(0.6),
              value: value1,
              title: '${value1.toStringAsFixed(0)}%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.4),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                    Shadow(
                      color: Colors.white.withOpacity(0.4),
                      offset: Offset(-1, 1),
                      blurRadius: 2,
                    ),
                    Shadow(
                      color: Colors.white.withOpacity(0.4),
                      offset: Offset(-1, -1),
                      blurRadius: 2,
                    ),
                    Shadow(
                      color: Colors.white.withOpacity(0.4),
                      offset: Offset(1, -1),
                      blurRadius: 2,
                    ),
                  ]));
        case 1:
          return PieChartSectionData(
              color: Colors.grey.withOpacity(0.6),
              value: value2,
              title: '${value2.toStringAsFixed(0)}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize - 2,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.9),
              ));
        default:
          throw Error();
      }
    });
  }
}
