import '../auth.dart';
import 'package:flutter/material.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({Key? key}) : super(key: key);

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

String password = "";
String rePassword = "";
String username = "";
bool equalPass = false;

class _NewAccountPageState extends State<NewAccountPage> {
  void createAccount() {
    Authentication.createAccount(username, password).then((success) {
      if (success) Navigator.pushNamed(context, 'inven');
    });
  }

  String password = "";
  String username = "";
  bool equalPass = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    FocusNode focus = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a New Account", style: TextStyle(fontSize: 18)),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * .03),
            Container(
              width: width * .63,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding:
                      EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  labelText: "Enter your Email",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Color(0xFFFF5A5A),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFFFF5A5A),
                    ),
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: width * .63,
              child: TextField(
                obscureText: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding:
                      EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  labelText: "Enter your Password",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Color(0xFFFF5A5A),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFFFF5A5A),
                    ),
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: width * .63,
              child: TextField(
                obscureText: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding:
                      EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  labelText: "Re-Enter your Password",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Color(0xFFFF5A5A),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: equalPass ? Colors.green : Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: equalPass ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                onChanged: (String value) {
                  rePassword = value;
                  if (value == password) {
                    setState(() {
                      equalPass = true;
                    });
                  } else {
                    setState(() {
                      equalPass = false;
                    });
                  }
                },
              ),
            ),
            if (!equalPass && rePassword.length > 0)
              Text("Passwords do not match",
                  style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: equalPass ? createAccount : null,
                child: Text("Sign up"))
          ],
        ),
      ),
    );
  }
}
