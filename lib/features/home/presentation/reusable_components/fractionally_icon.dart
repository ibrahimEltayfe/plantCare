import 'package:flutter/material.dart';

class FractionallyIcon extends StatelessWidget {
  final double heightFactor;
  final double widthFactor;
  final IconData icon;
  final Color color;
  const FractionallyIcon({Key? key, required this.heightFactor, required this.widthFactor, required this.icon, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: Center(
          child: FittedBox(
              child: Icon(icon,color: color)
          ),
        )
    );
  }
}
