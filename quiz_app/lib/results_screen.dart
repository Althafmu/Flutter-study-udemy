import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/quiz_summary.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.selectedAnswers,
    required this.restartQuiz,
  });

  final List<String> selectedAnswers;
  final void Function() restartQuiz;

  List<Map<String, Object>> getResults() {
    final List<Map<String, Object>> summary = [];
    for (int i = 0; i < selectedAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answers[0],
        'user_answer': selectedAnswers[i],
      });
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final totalCorrectAnswers =
        getResults().where((result) {
          return result['correct_answer'] == result['user_answer'];
        }).length;
    return Container(
      margin: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You answered $totalCorrectAnswers out of ${selectedAnswers.length} questions correct!",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          QuizSummary(getResults()),
          const SizedBox(height: 20),
          TextButton.icon(
            icon: Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: restartQuiz,
            label: const Text(
              "Restart Quiz",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
