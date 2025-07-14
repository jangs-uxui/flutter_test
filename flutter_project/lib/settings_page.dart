import 'package:flutter/material.dart';

import 'app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: 
      Center(
        child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, size: 30, color: AppColors.subTextColor),
                SizedBox(width: 3),
                Text("Settings",
                  style: TextStyle(
                      color: AppColors.subTextColor,
                      fontSize: 24
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
