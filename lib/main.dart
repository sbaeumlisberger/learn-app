import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learn_app/src/startup.dart';
import 'package:learn_app/src/theme.dart';
import 'package:learn_app/src/utils.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const LearnApp());
}

class LearnApp extends StatelessWidget {
  const LearnApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (context) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(builder: (context, theme, child) {
        return MaterialApp(
            onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(primarySwatch: Utils.toMaterialColor(theme.accentColor)),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Utils.toMaterialColor(theme.accentColor),
                appBarTheme: AppBarTheme(backgroundColor: Utils.toMaterialColor(theme.accentColor))),
            themeMode: theme.themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const StartupPage());
      }),
    );
  }
}
