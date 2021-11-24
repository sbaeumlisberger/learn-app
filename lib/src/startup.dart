import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learn_app/src/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    checkUsernameSet();
  }

  Future checkUsernameSet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isUsernameSet = preferences.containsKey("username");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              isUsernameSet ? const HomePage() : const WelcomePage()),
    );
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(msg.appStarting)],
          ),
        ),
      ),
    );
  }
}
