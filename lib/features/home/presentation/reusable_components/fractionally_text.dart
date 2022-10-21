import 'package:flutter/material.dart';

class FractionallyText extends StatelessWidget {
  final double heightFactor;
  final double widthFactor;
  final String text;
  final TextStyle textStyle;
  const FractionallyText({Key? key, required this.heightFactor, required this.widthFactor, required this.text, required this.textStyle, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: widthFactor,
          height: heightFactor,
          child: Center(
            child: FittedBox(
                child: Text(text,style: textStyle)
            ),
          )
      ),
    );
  }
}
