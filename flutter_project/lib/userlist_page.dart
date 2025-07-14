import 'package:flutter/material.dart';

import 'app_colors.dart';

class UserlistPage extends StatelessWidget {
  const UserlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      body:
      Center(
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_box_rounded, size: 30, color: AppColors.subTextColor),
            SizedBox(width: 5),
            Text("User List",
              style: TextStyle(
                  color: AppColors.subTextColor,
                  fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
