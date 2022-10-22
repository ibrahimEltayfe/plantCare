import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final TextStyle textStyle;
  final TextAlign? textAlign;
  const FittedText({Key? key, required this.height, required this.width, required this.text, required this.textStyle, this.textAlign, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: FittedBox(
            child: Text(
              text,
              style: textStyle,
              textAlign: textAlign
            )
        )
    );
  }
}
