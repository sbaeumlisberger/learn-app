import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  Duration challengeTime = const Duration(seconds: 30);

  Duration remainingTime = Duration.zero;

  Timer? timer;

  int num1 = 0;
  int num2 = 0;

  int answer1 = 0;
  int answer2 = 0;
  int answer3 = 0;
  int answer4 = 0;

  int selectedAnswer = 0;

  int exercises = 0;

  bool finished = false;

  int? highscore;

  @override
  void initState() {
    super.initState();
    _startChallenge();
    SharedPreferences.getInstance().then((preferences) {
      highscore = preferences.getInt("highscore");
    });
  }

  void _startTimer() {
    timer?.cancel();
    timer = null;
    remainingTime = challengeTime;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        remainingTime = Duration(seconds: remainingTime.inSeconds - 1);
        if (remainingTime.inSeconds == 0) {
          timer?.cancel();
          timer = null;
          finished = true;
          SharedPreferences.getInstance().then((preferences) => preferences.setInt("highscore", exercises));
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                child: _buildChallengeView(msg),
                visible: !finished,
              ),
              Visibility(
                child: _buildEndView(msg, context),
                visible: finished,
              )
            ])));
  }

  Column _buildChallengeView(AppLocalizations msg) {
    return Column(children: <Widget>[
      LinearProgressIndicator(
        value: remainingTime.inSeconds / challengeTime.inSeconds,
      ),
      const SizedBox(height: 4),
      Text(msg.remainingTime(remainingTime.inSeconds)),
      Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(num1.toString() + " * " + num2.toString(), style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 64),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildAnswerButton(answer1),
          buildAnswerButton(answer2),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildAnswerButton(answer3),
          buildAnswerButton(answer4),
        ])
      ]))
    ]);
  }

  Padding buildAnswerButton(int answer) {
    int expectedResult = num1 * num2;
    return Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
            onPressed: () {
              selectedAnswer == 0 ? _check(answer) : null;
            },
            child: Text(answer.toString(), style: const TextStyle(fontSize: 16)),
            style: selectedAnswer == answer
                ? ElevatedButton.styleFrom(
                    fixedSize: const Size(64, 64), primary: expectedResult == answer ? Colors.lightGreen : Colors.red)
                : ElevatedButton.styleFrom(fixedSize: const Size(64, 64))));
  }

  Column _buildEndView(AppLocalizations msg, BuildContext context) {
    String language = Localizations.localeOf(context).languageCode;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Visibility(
        child: Image(image: AssetImage('images/robot_new_highscore_' + language + '.png')),
        visible: isNewHighscore(),
      ),
      Visibility(
        child: Image(image: AssetImage('images/robot_good_result_' + language + '.png')),
        visible: !isNewHighscore() && isGoodResult(),
      ),
      Visibility(
        child: Image(image: AssetImage('images/robot_bad_result_' + language + '.png')),
        visible: !isNewHighscore() && !isGoodResult(),
      ),
      const SizedBox(height: 32),
      Text(msg.challengeResultMessage(exercises), textAlign: TextAlign.center),
      const SizedBox(height: 32),
      ElevatedButton(onPressed: _startChallenge, child: Text(msg.continuePractice)),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: _backToMenu, child: Text(msg.backToMenu))
    ]);
  }

  void _startChallenge() {
    _next();
    setState(() {
      exercises = 0;
      finished = false;
    });
    _startTimer();
  }

  void _next() {
    setState(() {
      num1 = Random().nextInt(10) + 1;
      num2 = Random().nextInt(10) + 1;
      int result = num1 * num2;
      int correctAnswer = Random().nextInt(4) + 1;
      answer1 = correctAnswer == 1 ? result : _randomResult([result]);
      answer2 = correctAnswer == 2 ? result : _randomResult([result, answer1]);
      answer3 = correctAnswer == 3 ? result : _randomResult([result, answer1, answer2]);
      answer4 = correctAnswer == 4 ? result : _randomResult([result, answer1, answer2, answer3]);
      selectedAnswer = 0;
    });
  }

  int _randomResult(List<int> exclude) {
    int result = 0;
    do {
      result = Random().nextInt(100) + 1;
    } while (exclude.contains(result));
    return result;
  }

  void _check(int answer) async {
    int expectedResult = num1 * num2;

    bool answerCorrect = answer == expectedResult;

    setState(() {
      selectedAnswer = answer;
    });

    if (answerCorrect) {
      exercises++;
      Future.delayed(const Duration(milliseconds: 500), _next);
    } else {
      Future.delayed(const Duration(milliseconds: 500), _resetSelection);
    }
  }

  void _resetSelection() {
    setState(() {
      selectedAnswer = 0;
    });
  }

  bool isNewHighscore() {
    return exercises > (highscore ?? 0);
  }

  bool isGoodResult() {
    return exercises > (highscore ?? 10) * 0.7;
  }

  void _backToMenu() {
    Navigator.pop(context);
  }
}
