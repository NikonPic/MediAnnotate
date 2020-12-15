import 'package:flutter/material.dart';

class ToggleDrawZoomIcon extends StatelessWidget {
  const ToggleDrawZoomIcon({
    Key key,
    @required this.zoomMode,
  }) : super(key: key);
  final bool zoomMode;

  final Color inactive = Colors.grey;
  final Color active = Colors.green;
  final double sizeActive = 35;
  final double sizeInactive = 12;

  @override
  Widget build(BuildContext context) {
    return zoomMode
        ? Row(
            children: [
              Icon(
                Icons.create,
                color: inactive,
                size: sizeInactive,
              ),
              Icon(
                Icons.zoom_in_rounded,
                color: active,
                size: sizeActive,
              ),
            ],
          )
        : Row(
            children: [
              Icon(
                Icons.create,
                color: active,
                size: sizeActive,
              ),
              Icon(
                Icons.zoom_in_rounded,
                color: inactive,
                size: sizeInactive,
              ),
            ],
          );
  }
}
