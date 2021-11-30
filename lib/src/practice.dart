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
  final _numberOfExercises = 10;

  final _resultController = TextEditingController();

  int _exercise = 1;

  int _num1 = Random().nextInt(10) + 1;
  int _num2 = Random().nextInt(10) + 1;

  bool _showResult = false;

  bool _answerCorrect = false;

  int _correctAnswers = 0;

  bool _finished = false;

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
        child: Stack(
          children: <Widget>[
            Visibility(
              child: _buildPracticeView(msg),
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

  Widget _buildPracticeView(AppLocalizations msg) {
    return Column(
      children: <Widget>[
        LinearProgressIndicator(
          value: (_exercise - 1) / _numberOfExercises,
        ),
        const SizedBox(height: 4),
        Text(msg.exerciseOf(_exercise, _numberOfExercises)),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(_num1.toString() + " * " + _num2.toString(), style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 24),
                  TextField(
                      controller: _resultController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 32),
                  Visibility(
                    child: ElevatedButton(
                      onPressed: _check,
                      child: Text(msg.check),
                    ),
                    visible: !_showResult,
                  ),
                  Visibility(
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        color: _answerCorrect ? Colors.lightGreen : Colors.red,
                        child: Text(
                          _answerCorrect ? msg.correct : msg.wrong,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        )),
                    visible: _showResult,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEndView(AppLocalizations msg, BuildContext context) {
    String language = Localizations.localeOf(context).languageCode;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              child: Image(image: AssetImage('images/robot_good_result_' + language + '.png'), height: 300),
              visible: _correctAnswers >= _numberOfExercises * 0.7,
            ),
            Visibility(
              child: Image(image: AssetImage('images/robot_bad_result_' + language + '.png'), height: 300),
              visible: _correctAnswers < _numberOfExercises * 0.7,
            ),
            const SizedBox(height: 32),
            Text(msg.practiceResultMessage(_correctAnswers, _numberOfExercises), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _continuePractice, child: Text(msg.continuePractice)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _backToMenu, child: Text(msg.backToMenu))
          ],
        ),
      ),
    );
  }

  void _check() async {
    int? answer = int.tryParse(_resultController.value.text);

    int expectedResult = _num1 * _num2;

    setState(() {
      _answerCorrect = answer == expectedResult;

      if (_answerCorrect) {
        _correctAnswers++;
      }

      _showResult = true;
    });

    Future.delayed(const Duration(milliseconds: 500), _next);
  }

  void _next() async {
    if (_exercise < _numberOfExercises) {
      setState(() {
        _exercise++;
        _num1 = Random().nextInt(10) + 1;
        _num2 = Random().nextInt(10) + 1;
        _resultController.clear();
        _showResult = false;
      });
    } else {
      setState(() {
        _finished = true;
      });
    }
  }

  void _continuePractice() {
    setState(() {
      _exercise = 1;
      _num1 = Random().nextInt(10) + 1;
      _num2 = Random().nextInt(10) + 1;
      _resultController.clear();
      _correctAnswers = 0;
      _showResult = false;
      _finished = false;
    });
  }

  void _backToMenu() {
    Navigator.pop(context);
  }
}
