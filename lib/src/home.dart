import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learn_app/src/persistence_service.dart';
import 'package:learn_app/src/practice.dart';
import 'package:learn_app/src/challenge.dart';
import 'package:learn_app/src/service_locator.dart';
import 'package:learn_app/src/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final _persistenceService = getIt<PersistenceService>();

  final menuTextStyle = const TextStyle(fontSize: 20);
  final menuButtonStyle = ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(64));

  String username = "";
  int highscore = 0;

  @override
  void initState() {
    super.initState();
    username = _persistenceService.getString("username") ?? "";
    highscore = _persistenceService.getInt("highscore") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    var msg = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(msg.appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 64.0),
        child: Column(
          children: [
            Text(msg.highscore(highscore)),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(msg.homeHello(username), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(msg.homeQuestion),
                      const SizedBox(height: 32),
                      ElevatedButton(
                          onPressed: _practice, child: Text(msg.learn, style: menuTextStyle), style: menuButtonStyle),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: _challenge,
                          child: Text(msg.challenge, style: menuTextStyle),
                          style: menuButtonStyle),
                      const SizedBox(height: 32),
                      ElevatedButton(
                          onPressed: _settings, child: Text(msg.settings, style: menuTextStyle), style: menuButtonStyle)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateHighscore() {
    setState(() {
      highscore = _persistenceService.getInt("highscore") ?? 0;
    });
  }

  void _practice() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PracticePage()),
    );
  }

  void _challenge() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChallengePage()),
    ).then((value) => _updateHighscore());
  }

  void _settings() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }
}
