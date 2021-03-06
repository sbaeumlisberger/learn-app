import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learn_app/src/home.dart';
import 'package:learn_app/src/persistence_service.dart';
import 'package:learn_app/src/service_locator.dart';
import 'package:learn_app/src/theme.dart';
import 'package:learn_app/src/utils.dart';
import 'package:learn_app/src/welcome.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await setupServiceLocator(); // Registers the services to be used in the app
  runApp(const LearnApp()); // Start the app
}

/// Primary widget of the app. Handles theme settings and shows the first page.
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
            home: getIt<PersistenceService>().existsKey("username") ? const HomePage() : const WelcomePage());
      }),
    );
  }
}
