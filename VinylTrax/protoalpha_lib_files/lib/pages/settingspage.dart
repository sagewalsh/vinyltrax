library my_prj.globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool listBool = false;
bool darkTheme = false;

class SettingsPage extends StatefulWidget {

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool valNotify3 = true;

  changeTheme(bool newVal) {
    setState(() {
      darkTheme = newVal;
    });
  }

  listMode(bool newVal) {
    setState(() {
      listBool = newVal;
    });
  }

  changeFunct3(bool newVal) {
    setState(() {
      valNotify3 = newVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDF6),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFDF6),
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text(
            "Settings Page",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Row(children: [
              Icon(
                Icons.person,
                color: Color(0xFFFF5A5A),
              ),
              SizedBox(width: 10),
              Text("Account", style: TextStyle(fontSize: 22))
            ]),
            Divider(height: 10, thickness: 1),
            SizedBox(height: 10),
            accountOptions(context, "Account Details"),
            accountOptions(context, "Delete Account"),
            accountOptions(context, "Log Out"),
            SizedBox(height: 40),
            Row(children: [
              Icon(
                Icons.settings_suggest,
                color: Color(0xFFFF5A5A),
              ),
              SizedBox(width: 10),
              Text("Others", style: TextStyle(fontSize: 22))
            ]),
            Divider(height: 10, thickness: 1),
            SizedBox(height: 10),
            otherOptions("Dark Theme", darkTheme, changeTheme),
            otherOptions("List Mode", listBool, listMode),
            otherOptions("Test3", valNotify3, changeFunct3),
          ],
        ),
      ),
    );
  }

  GestureDetector accountOptions(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        //print("works");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600])),
            Icon(Icons.arrow_forward_ios, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Padding otherOptions(String title, bool value, Function onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              )),
          Transform.scale(
            scale: .7,
            child: CupertinoSwitch(
              activeColor: Color(0xFFFF5A5A),
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChange(newValue);
              },
            ),
          ),
        ],
      ),
    );
  }
}
