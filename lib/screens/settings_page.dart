import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),

      body: Consumer<ThemeProvider>(
        builder: (ctx, provider, __) {
          return SwitchListTile.adaptive(
            title: Text("Change theme"),
            subtitle: Text("Change to dark mode"),
            onChanged: (value) {
              provider.updateTheme(value: value);
            },
            value: provider.getThemeValue(),
          );
        },
      ),
    );
  }
}
