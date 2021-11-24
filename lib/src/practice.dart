import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({Key? key}) : super(key: key);

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final numberOfExercises = 10;

  final resultController = TextEditingController();

  int exercise = 1;

  int num1 = Random().nextInt(11);
  int num2 = Random().nextInt(11);

  bool showResult = false;

  bool answerCorrect = false;

  int correctAnswers = 0;

  bool finished = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var msg = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          title: Text(msg.appTitle),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(children: <Widget>[
              Visibility(
                child: _buildLearnView(msg),
                visible: !finished,
              ),
              Visibility(
                child: _buildEndView(msg, context),
                visible: finished,
              )
            ])));
  }

  Column _buildLearnView(AppLocalizations msg) {
    return Column(
      children: <Widget>[
        LinearProgressIndicator(
          value: (exercise - 1) / numberOfExercises,
        ),
        const SizedBox(height: 4),
        Text(msg.exerciseOf(exercise, numberOfExercises)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(num1.toString() + " * " + num2.toString(),
                  style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 24),
              TextField(
                  controller: resultController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 32),
              Visibility(
                child: ElevatedButton(
                  onPressed: _check,
                  child: Text(msg.check),
                ),
                visible: !showResult,
              ),
              Visibility(
                child: Container(
                    padding: const EdgeInsets.all(6),
                    width: double.infinity,
                    color: answerCorrect ? Colors.lightGreen : Colors.red,
                    child: Text(
                      answerCorrect ? msg.correct : msg.wrong,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    )),
                visible: showResult,
              )
            ],
          ),
        ),
      ],
    );
  }

  Column _buildEndView(AppLocalizations msg, BuildContext context) {
    String language = Localizations
        .localeOf(context)
        .languageCode;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          child: Image(
              image:
              AssetImage('images/robot_good_result_' + language + '.png')),
          visible: correctAnswers >= numberOfExercises * 0.7,
        ),
        Visibility(
          child: Image(
              image:
              AssetImage('images/robot_bad_result_' + language + '.png')),
          visible: correctAnswers < numberOfExercises * 0.7,
        ),
        const SizedBox(height: 32),
        Text(msg.practiceResultMessage(correctAnswers, numberOfExercises),
            textAlign: TextAlign.center),
        const SizedBox(height: 32),
        ElevatedButton(
            onPressed: _continuePractice, child: Text(msg.continuePractice)),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _backToMenu, child: Text(msg.backToMenu))
      ],
    );
  }

  void _check() async {
    int? answer = int.tryParse(resultController.value.text);

    int expectedResult = num1 * num2;

    setState(() {
      answerCorrect = answer == expectedResult;

      if (answerCorrect) {
        correctAnswers++;
      }

      showResult = true;
    });

    Future.delayed(const Duration(milliseconds: 500), _next);
  }

  void _next() async {
    if (exercise < numberOfExercises) {
      setState(() {
        exercise++;
        num1 = Random().nextInt(10) + 1;
        num2 = Random().nextInt(10) + 1;
        resultController.clear();
        showResult = false;
      });
    } else {
      setState(() {
        finished = true;
      });
    }
  }

  void _continuePractice() {
    setState(() {
      exercise = 1;
      num1 = Random().nextInt(11);
      num2 = Random().nextInt(11);
      resultController.clear();
      correctAnswers = 0;
      showResult = false;
      finished = false;
    });
  }

  void _backToMenu() {
    Navigator.pop(context);
  }
}
