import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learn_app/src/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// The settings page allows the user to change the theme and accent color.
/// Furthermore credits and a link to the source code are part of the page
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _titleStyle = const TextStyle(fontSize: 24);

  /// color selected by the user via color picker dialog
  Color? _customColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var msg = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(msg.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(msg.themeTitle, style: _titleStyle),
              DropdownButton(
                  items: [
                    DropdownMenuItem(child: Text(msg.themeSystem), value: ThemeMode.system),
                    DropdownMenuItem(child: Text(msg.themeLight), value: ThemeMode.light),
                    DropdownMenuItem(child: Text(msg.themeDark), value: ThemeMode.dark)
                  ],
                  value: Provider.of<ThemeNotifier>(context).themeMode,
                  onChanged: (ThemeMode? themeMode) =>
                      Provider.of<ThemeNotifier>(context, listen: false).changeThemeMode(themeMode!)),
              const SizedBox(height: 32),
              Text(msg.colorTitle, style: _titleStyle),
              _buildSimpleColorPicker(),
              const SizedBox(height: 4),
              ElevatedButton(
                  onPressed: () {
                    _showAdvancedColorPicker(context);
                  },
                  child: Text(msg.colorPickerButton)),
              const SizedBox(height: 32),
              Text(msg.creditsTitle, style: _titleStyle),
              const SizedBox(height: 4),
              InkWell(
                  child: const Text('Logo vector created by roserodionova - www.freepik.com'),
                  onTap: () => launch('https://www.freepik.com/vectors/logo')),
              // https://www.freepik.com/free-vector/cute-bot-say-users-hello-chatbot-greets-online-consultation_4015765.htm#page=1&query=roboter&position=0&from_view=search",
              const SizedBox(height: 32),
              Text(msg.sourceCodeTitle, style: _titleStyle),
              const SizedBox(height: 4),
              InkWell(
                  child: Text(msg.sourceCodeLink), onTap: () => launch('https://github.com/sbaeumlisberger/learn-app')),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a color picker with some predefined colors and a custom color chosen by the user.
  Widget _buildSimpleColorPicker() {
    // if no custom color selected, fallback to users accentColor
    _customColor ??= Provider.of<ThemeNotifier>(context).accentColor;
    return BlockPicker(
      // use unique key to force update of selected color when changed via dialog
      key: UniqueKey(),
      availableColors: [
        Colors.blue,
        Colors.indigo,
        Colors.purple,
        Colors.deepOrange,
        Colors.amber,
        Colors.lime,
        _customColor! // can never be null because of fallback to accent color
      ].distinct(by: (color) => color.value),
      // remove duplicates (custom color may be a predefined color)
      pickerColor: Provider.of<ThemeNotifier>(context).accentColor,
      onColorChanged: (color) => Provider.of<ThemeNotifier>(context, listen: false).changeAccentColor(color),
      layoutBuilder: (BuildContext context, List<Color> colors, PickerItem child) {
        return GridView.count(
            shrinkWrap: true, crossAxisCount: 8, children: [for (Color color in colors) child(color)]);
      },
    );
  }

  /// Shows an advanced color picker which allows the user to chose a custom color.
  void _showAdvancedColorPicker(BuildContext context) {
    Color pickedColor = Provider.of<ThemeNotifier>(context, listen: false).accentColor;
    var msg = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg.colorPickerTitle),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickedColor,
              enableAlpha: false,
              onColorChanged: (color) {
                pickedColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text(msg.colorPickerCancel),
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
              },
            ),
            TextButton(
              child: Text(msg.colorPickerConfirm),
              onPressed: () async {
                setState(() {
                  _customColor = pickedColor;
                });
                await Provider.of<ThemeNotifier>(context, listen: false).changeAccentColor(pickedColor);
                Navigator.of(context).pop(); // close dialog
              },
            )
          ],
        );
      },
    );
  }
}
