import 'package:flutter/material.dart';

class GradientScreen extends StatelessWidget {
  const GradientScreen(this.startQuiz, {super.key});

  final void Function() startQuiz;

  @override
  Widget build(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage("assets/images/quiz-logo.png"), width: 300),
        SizedBox(height: 50),
        Text(
          "Learn Flutter the fun way!",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () {
            startQuiz();
          },
          icon: Icon(Icons.play_arrow, color: Colors.white),
          label: Text(
            "Start Quiz",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
