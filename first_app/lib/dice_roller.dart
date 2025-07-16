import 'dart:math';

import 'package:first_app/styled_text.dart';
import 'package:flutter/material.dart';

final Randomizer = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller> {
  var currentDiceroll = 2;
  void rollDice() {
    setState(() {
      currentDiceroll = Randomizer.nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const StyledText("Hello, Flutter!", 32),
        const StyledText("Welcome to the Flutter course!", 22),
        const SizedBox(height: 100),
        StyledText("This is roll Dice! App", 22),
        StyledText("Click the button to roll", 22),
        const SizedBox(height: 40),
        Image(
          image: AssetImage("assets/images/dice-$currentDiceroll.png"),
          width: 200,
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: rollDice, child: const Text("Roll Dice")),
      ],
    );
  }
}
