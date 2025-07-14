import 'package:flutter/material.dart';
import 'package:flutter_project/app_colors.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("First Page"),
        ),
        drawer: MenuDrawer(),
        body: Center(
          child: Text("환영합니다.",
            style: TextStyle(fontSize: 24, color: AppColors.textColor),
          ),
        )
    );
  }
}


class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  final String myName = "김철수";
  final String email = "email@gmail.com";
  final String phone = "010-1234-1234";
  final String address = "서울시 서초구 서초동";

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/img02.jpg"),
              backgroundColor: AppColors.disabledColor,
            ),
            accountName: Text(widget.myName,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
            ),
            accountEmail: Text(widget.email,
              style: TextStyle(
                  fontSize: 15
              ),
            ),
            decoration: BoxDecoration(
                color: AppColors.mainColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(100),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3)
                  )
                ]
            ),
            onDetailsPressed: () {
              setState(() {
                this.showDetails = !(this.showDetails);
              });
            },
          ),
          if (this.showDetails)
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 5, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone, color: AppColors.subTextColor, size: 20),
                      SizedBox(width: 5),
                      Text("Phone : ${widget.phone}",
                        style: TextStyle(fontSize: 16, color: AppColors.textColor),
                      )
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: AppColors.subTextColor, size: 20),
                      SizedBox(width: 5),
                      Text("Address : ${widget.address}",
                        style: TextStyle(fontSize: 16, color: AppColors.textColor),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ListTile(
            leading: Icon(Icons.home, color: AppColors.subTextColor,),
            title: Text("Home"),
            trailing: Icon(Icons.navigate_next, color: AppColors.subTextColor,),
            onTap: () {
              Navigator.pushNamed(context, "/");
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box_rounded, color: AppColors.subTextColor,),
            title: Text("User List"),
            trailing: Icon(Icons.navigate_next, color: AppColors.subTextColor,),
            onTap: () {
              Navigator.pushNamed(context, "/userlist");
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.subTextColor,),
            title: Text("Settings"),
            trailing: Icon(Icons.navigate_next, color: AppColors.subTextColor,),
            onTap: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
        ],
      ),
    );
  }
}
