import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learn_app/src/persistence_service.dart';
import 'package:learn_app/src/service_locator.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

/// The challenge page show the user exercises until the specified time has elapsed.
/// The user has to answer the exercises via multiple choice.
/// At the end the results are shown and the user can retry or return to the menu.
class _ChallengePageState extends State<ChallengePage> {
  final _persistenceService = getIt<PersistenceService>();

  /// The duration the user has to answer exercises.
  final Duration _challengeTime = const Duration(seconds: 30);

  Duration _remainingTime = Duration.zero;

  Timer? _timer;

  int _num1 = 0;
  int _num2 = 0;

  int _answer1 = 0;
  int _answer2 = 0;
  int _answer3 = 0;
  int _answer4 = 0;

  /// The value of the selected answer or 0 if no answer is selected
  int _selectedAnswer = 0;

  /// the number of exercises the user has solved
  int _exercises = 0;

  bool _newHighscore = false;
  bool _goodResult = false;
  bool _badResult = false;

  bool _finished = false;

  int _highscore = 0;

  @override
  void initState() {
    super.initState();
    _highscore = _persistenceService.getInt("highscore") ?? 0;
    _startChallenge();
  }

  @override
  void dispose() {
    _timer?.cancel();
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
        child: Stack(
          children: <Widget>[
            Visibility(
              child: _buildChallengeView(msg),
              visible: !_finished,
            ),
            Visibility(
              child: _buildEndView(msg, context),
              visible: _finished,
            )
          ],
        ),
      ),
    );
  }

  /// Builds the challenge view showing the exercises and four buttons with answers.
  Widget _buildChallengeView(AppLocalizations msg) {
    return Column(
      children: <Widget>[
        LinearProgressIndicator(
          value: _remainingTime.inSeconds / _challengeTime.inSeconds,
        ),
        const SizedBox(height: 4),
        Text(msg.remainingTime(_remainingTime.inSeconds)),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(_num1.toString() + " * " + _num2.toString(), style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnswerButton(_answer1),
                      _buildAnswerButton(_answer2),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnswerButton(_answer3),
                      _buildAnswerButton(_answer4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  /// Builds an answer button. When the button is pressed it is
  /// highlighted green for the correct answer, otherwise red.
  Widget _buildAnswerButton(int answer) {
    int expectedResult = _num1 * _num2;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          // ignore while an answer is selected
          if (_selectedAnswer == 0) {
            _check(answer);
          }
        },
        child: Text(answer.toString(), style: const TextStyle(fontSize: 20)),
        style: _selectedAnswer == answer
            ? ElevatedButton.styleFrom(
                fixedSize: const Size(128, 128), primary: expectedResult == answer ? Colors.lightGreen : Colors.red)
            : ElevatedButton.styleFrom(fixedSize: const Size(128, 128)),
      ),
    );
  }

  /// Builds the result view.
  Widget _buildEndView(AppLocalizations msg, BuildContext context) {
    String language = Localizations.localeOf(context).languageCode;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
                child: Image(image: AssetImage('images/robot_new_highscore_' + language + '.png'), height: 300),
                visible: _newHighscore),
            Visibility(
              child: Image(image: AssetImage('images/robot_good_result_' + language + '.png'), height: 300),
              visible: _goodResult,
            ),
            Visibility(
              child: Image(image: AssetImage('images/robot_bad_result_' + language + '.png'), height: 300),
              visible: _badResult,
            ),
            const SizedBox(height: 32),
            Text(msg.challengeResultMessage(_exercises), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _startChallenge, child: Text(msg.continuePractice)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _backToMenu, child: Text(msg.backToMenu))
          ],
        ),
      ),
    );
  }

  /// Shows the first exercises and starts the timer.
  void _startChallenge() {
    _next();
    setState(() {
      _exercises = 0;
      _finished = false;
    });
    _startTimer();
  }

  /// Shows a new exercise.
  void _next() {
    setState(() {
      _num1 = Random().nextInt(10) + 1;
      _num2 = Random().nextInt(10) + 1;
      int result = _num1 * _num2;
      int correctAnswer = Random().nextInt(4) + 1;
      _answer1 = correctAnswer == 1 ? result : _randomResult([result]);
      _answer2 = correctAnswer == 2 ? result : _randomResult([result, _answer1]);
      _answer3 = correctAnswer == 3 ? result : _randomResult([result, _answer1, _answer2]);
      _answer4 = correctAnswer == 4 ? result : _randomResult([result, _answer1, _answer2, _answer3]);
      _selectedAnswer = 0;
    });
  }

  /// Starts a new timer.
  void _startTimer() {
    _remainingTime = _challengeTime; // reset remaining time
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _timerCallback());
  }

  /// Called periodically by the timer. Updates the remaining time
  /// and show the result view when the time has elapsed.
  Future<void> _timerCallback() async {
    setState(() {
      _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
      if (_remainingTime.inSeconds == 0) {
        _timer?.cancel();
        _timer = null;
        _newHighscore = _exercises > _highscore;
        // for a good result min 70% of current highscore are required
        _goodResult = !_newHighscore && _exercises >= _highscore * 0.7;
        _badResult = !_newHighscore && !_goodResult;
        _finished = true;
      }
    });
    if (_remainingTime.inSeconds == 0 && _newHighscore) {
      _highscore = _exercises;
      await _persistenceService.setInt("highscore", _exercises);
    }
  }

  /// Generates a random exercise result excluding the specified values.
  int _randomResult(List<int> exclude) {
    int result = 0;
    do {
      result = Random().nextInt(100) + 1;
    } while (exclude.contains(result));
    return result;
  }

  /// Checks the specified answer and shows visual feedback.
  void _check(int answer) async {
    int expectedResult = _num1 * _num2;

    bool answerCorrect = answer == expectedResult;

    setState(() {
      _selectedAnswer = answer;
    });

    if (answerCorrect) {
      _exercises++;
      // show next exercises after 500ms feedback
      Future.delayed(const Duration(milliseconds: 500), _next);
    } else {
      // allow new try after 500ms feedback
      Future.delayed(const Duration(milliseconds: 500), _resetSelection);
    }
  }

  /// Resets the visual feedback
  void _resetSelection() {
    setState(() {
      _selectedAnswer = 0;
    });
  }

  void _backToMenu() {
    Navigator.pop(context);
  }
}
