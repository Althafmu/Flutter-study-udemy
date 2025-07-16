import 'package:flutter/material.dart';

class QuizSummary extends StatelessWidget {
  const QuizSummary(this.summaryData, {super.key});
  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children:
              summaryData.map((data) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            data['correct_answer'] == data['user_answer']
                                ? const Color.fromARGB(255, 138, 185, 224)
                                : const Color.fromARGB(255, 201, 136, 131),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ((data['question_index'] as int) + 1).toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['question'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              data['user_answer'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    data['correct_answer'] ==
                                            data['user_answer']
                                        ? const Color.fromARGB(
                                          255,
                                          121,
                                          233,
                                          125,
                                        )
                                        : const Color.fromARGB(
                                          255,
                                          237,
                                          150,
                                          144,
                                        ),
                              ),
                            ),
                            Text(
                              data['correct_answer'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 138, 185, 224),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
