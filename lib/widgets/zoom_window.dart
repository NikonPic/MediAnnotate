import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../core/constants.dart';
import '../functionality/signature.dart';

class DrawZoomWindow extends StatefulWidget {
  const DrawZoomWindow({
    Key key,
    @required this.imageName,
    @required this.controller,
  }) : super(key: key);
  final String imageName;
  final PhotoViewController controller;

  @override
  _DrawZoomWindowState createState() =>
      _DrawZoomWindowState(imageName: imageName);
}

class _DrawZoomWindowState extends State<DrawZoomWindow> {
  final String imageName;
  // the local state
  List<Offset> _points = <Offset>[];
  double initScale = 0;

  _DrawZoomWindowState({@required this.imageName});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InteractiveViewer(
      panEnabled: false,
      onInteractionStart: (ScaleStartDetails details) {
        setState(() {
          initScale = 1.0;
        });
        print(details.toString());
      },
      onInteractionUpdate: (ScaleUpdateDetails details) {
        setState(
          () {
            final Offset _localPosition = details.focalPoint;
            _points = List.from(_points)..add(_localPosition);
          },
        );
      },
      onInteractionEnd: (_) => _points.add(null),
      minScale: 1.0,
      maxScale: 4.0,
      child: Stack(
        children: [
          ImageChild(imageName: imageName),
          CustomPaint(
            painter: Signature(
              points: _points,
              color: Colors.deepOrange,
              strokeWidth: 3,
            ),
            size: size,
          ),
        ],
      ),
    );
  }
}

class ImageChild extends StatelessWidget {
  const ImageChild({
    Key key,
    @required this.imageName,
  }) : super(key: key);

  final String imageName;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(imageName),
          fit: BoxFit.fitWidth,
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.3),
          )
        ],
      ),
    );
  }
}
