import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, this.fsize, {super.key});

  final String text;
  final double fsize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fsize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
