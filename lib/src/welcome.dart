import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learn_app/src/home.dart';
import 'package:learn_app/src/persistence_service.dart';
import 'package:learn_app/src/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _persistenceService = getIt<PersistenceService>();

  final _nameController = TextEditingController();

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Image(image: AssetImage('images/robot_hello.png'), height: 300),
                Text(msg.nameLabel),
                TextField(controller: _nameController, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _next,
                  child: Text(msg.next),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _next() async {
    // persist entered username
    await _persistenceService.setString('username', _nameController.value.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
