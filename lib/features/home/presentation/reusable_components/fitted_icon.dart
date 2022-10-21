import 'package:flutter/material.dart';

class FittedIcon extends StatelessWidget {
  final double height;
  final double width;
  final IconData icon;
  final Color color;
  const FittedIcon({Key? key, required this.height, required this.width, required this.icon, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: FittedBox(
              child: Icon(icon,color: color)
          ),
        )
    );
  }
}
