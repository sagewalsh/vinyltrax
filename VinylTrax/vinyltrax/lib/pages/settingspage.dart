import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool valNotify1 = true;
  bool valNotify2 = false;
  bool valNotify3 = true;

  changeFunct1(bool newValue1) {
    setState(() {
      valNotify1 = newValue1;
    });
  }

  changeFunct2(bool newValue2) {
    setState(() {
      valNotify2 = newValue2;
    });
  }

  changeFunct3(bool newValue3) {
    setState(() {
      valNotify3 = newValue3;
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
            otherOptions("Dark Theme", valNotify1, changeFunct1),
            otherOptions("Test2", valNotify2, changeFunct2),
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
