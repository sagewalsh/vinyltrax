import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyltrax/auth.dart';
import 'package:vinyltrax/inventory/database.dart';
import 'package:vinyltrax/pages/settingspage.dart';
/*
##########################################################################
ACCOUNT DETAILS PAGE
##########################################################################
*/

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({Key? key}) : super(key: key);

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPage();
}

class _AccountDetailsPage extends State<AccountDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Screen Sizes
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Future<List<String>> _results = Database.getUser();

    return Scaffold(
      backgroundColor: darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
      appBar: AppBar(
        toolbarHeight: height * .1,
        backgroundColor: darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
        leading: BackButton(
          color: darkTheme ? Colors.white : Colors.black,
        ),
        title: Text(
          "Account Details",
          style: TextStyle(
            color: darkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: FutureBuilder<List<dynamic>>(
              future: _results,
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[];
                  var data = snapshot.data!;

                  if (data.length != 0) {
                    children = [
                      /*
                      ##########################################################
                      Name on the Account
                      ##########################################################
                      */
                      ListTile(
                        onTap: () {
                          String textToUpload = data[0];
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Name on the Account",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  content: TextField(
                                    maxLines: 1,
                                    controller: TextEditingController()
                                      ..text = data[0],
                                    focusNode: FocusNode(),
                                    cursorColor:
                                        darkTheme ? Colors.white : Colors.black,
                                    style: TextStyle(
                                      color: darkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onChanged: (String value) {
                                      textToUpload = value;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          if (textToUpload == "")
                                            textToUpload = "Anonymous";
                                          Database.updateName(textToUpload);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text("Save")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel")),
                                  ],
                                );
                              });
                        },
                        // Icon
                        leading: Container(
                          child: Image.asset(
                            "assets/username.png",
                            width: 25,
                            color: darkTheme
                                ? Color(0xFFBB86FC)
                                : Color(0xFFFF5A5A),
                          ),
                        ),

                        // Name
                        title: Container(
                          child: Text(
                            data[0],
                            style: TextStyle(
                              color: darkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                        ),

                        // Underline
                        subtitle: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: darkTheme
                                    ? Color(0x64BB86FC)
                                    : Color(0x64FF5A5A),
                                // color: Color.fromARGB(0, 255, 90, 90),
                              ),
                            ),
                          ),
                          child: Text(
                            " ",
                            style: TextStyle(fontSize: 5),
                          ),
                        ),
                      ),

                      /*
                      ##########################################################
                      Account Email (username)
                      ##########################################################
                      */
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Update email account \n${data[1]}?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  String oldEmail = data[1];
                                                  String password = "";
                                                  String newEmail = "";
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Update Email Address",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    content: Column(
                                                      children: [
                                                        // OLD EMAIL
                                                        Text(
                                                          "Outdated Email",
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        TextField(
                                                          maxLines: 1,
                                                          controller:
                                                              TextEditingController()
                                                                ..text =
                                                                    data[1],
                                                          focusNode:
                                                              FocusNode(),
                                                          cursorColor: darkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          onChanged:
                                                              (String value) {
                                                            oldEmail = value;
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),

                                                        // PASSWORD
                                                        Text(
                                                          "Password",
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        TextField(
                                                          maxLines: 1,
                                                          controller:
                                                              TextEditingController(),
                                                          focusNode:
                                                              FocusNode(),
                                                          cursorColor: darkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          onChanged:
                                                              (String value) {
                                                            password = value;
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),

                                                        // NEW EMAIL
                                                        Text(
                                                          "Outdated Email",
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        TextField(
                                                          maxLines: 1,
                                                          controller:
                                                              TextEditingController(),
                                                          focusNode:
                                                              FocusNode(),
                                                          cursorColor: darkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          onChanged:
                                                              (String value) {
                                                            newEmail = value;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            if (oldEmail == "")
                                                              oldEmail =
                                                                  data[1];

                                                            if (newEmail !=
                                                                "") {
                                                              Authentication
                                                                  .updateEmail(
                                                                newEmail,
                                                                oldEmail,
                                                                password,
                                                              ).then((success) {
                                                                if (success[
                                                                    0]) {
                                                                  Database.updateEmail(
                                                                      newEmail);
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                }
                                                              });
                                                            }
                                                          },
                                                          child: Text("Save")),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text("Cancel")),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text("Yes")),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); //returns user back to page
                                          },
                                          child: Text("No")),
                                    ],
                                  ),
                                );
                              });
                        },
                        leading: Container(
                          child: Icon(
                            Icons.email,
                            size: 25,
                            color: darkTheme
                                ? Color(0xFFBB86FC)
                                : Color(0xFFFF5A5A),
                          ),
                        ),

                        // Email
                        title: Container(
                          child: Text(
                            data[1],
                            style: TextStyle(
                              color: darkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                        ),

                        // Underline
                        subtitle: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: darkTheme
                                    ? Color(0x64BB86FC)
                                    : Color(0x64FF5A5A),
                                // color: Color.fromARGB(0, 255, 90, 90),
                              ),
                            ),
                          ),
                          child: Text(
                            " ",
                            style: TextStyle(fontSize: 5),
                          ),
                        ),
                      ),

                      /*
                      ##########################################################
                      Reset Password
                      ##########################################################
                      */
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Reset Password?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  String email = data[1];
                                                  String oldPassword = "";
                                                  String newPassword = "";
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Update Email Address",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    content: Column(
                                                      children: [
                                                        // OLD EMAIL
                                                        Text(
                                                          "Email",
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        TextField(
                                                          maxLines: 1,
                                                          controller:
                                                              TextEditingController()
                                                                ..text =
                                                                    data[1],
                                                          focusNode:
                                                              FocusNode(),
                                                          cursorColor: darkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          onChanged:
                                                              (String value) {
                                                            email = value;
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),

                                                        // PASSWORD
                                                        Text(
                                                          "Old Password",
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        TextField(
                                                          maxLines: 1,
                                                          controller:
                                                              TextEditingController(),
                                                          focusNode:
                                                              FocusNode(),
                                                          cursorColor: darkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          onChanged:
                                                              (String value) {
                                                            oldPassword = value;
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),

                                                        // NEW EMAIL
                                                        Text(
                                                          "New Password",
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        TextField(
                                                          maxLines: 1,
                                                          controller:
                                                              TextEditingController(),
                                                          focusNode:
                                                              FocusNode(),
                                                          cursorColor: darkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          style: TextStyle(
                                                            color: darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          onChanged:
                                                              (String value) {
                                                            newPassword = value;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            if (email == "")
                                                              email = data[1];
                                                            Authentication
                                                                .updatePassword(
                                                              email,
                                                              oldPassword,
                                                              newPassword,
                                                            ).then((success) {
                                                              if (success[0]) {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {});
                                                              }
                                                            });
                                                          },
                                                          child: Text("Save")),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text("Cancel")),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text("Yes")),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); //returns user back to page
                                          },
                                          child: Text("No")),
                                    ],
                                  ),
                                );
                              });
                        },
                        leading: Container(
                            child: Icon(
                          Icons.password,
                          size: 25,
                          color:
                              darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
                        )),

                        // Password
                        title: Container(
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              color: darkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                        ),

                        // Underline
                        subtitle: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: darkTheme
                                    ? Color(0x64BB86FC)
                                    : Color(0x64FF5A5A),
                                // color: Color.fromARGB(0, 255, 90, 90),
                              ),
                            ),
                          ),
                          child: Text(
                            " ",
                            style: TextStyle(fontSize: 5),
                          ),
                        ),
                      ),

                      /*
                      ##########################################################
                      Account Creation Date
                      ##########################################################
                      */
                      ListTile(
                        leading: Container(
                            child: Icon(
                          Icons.date_range,
                          size: 25,
                          color:
                              darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
                        )),

                        // Creation Date
                        title: Container(
                          child: Text(
                            data[2],
                            style: TextStyle(
                              color: darkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                        ),

                        // Underline
                        subtitle: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: darkTheme
                                    ? Color(0x64BB86FC)
                                    : Color(0x64FF5A5A),
                                // color: Color.fromARGB(0, 255, 90, 90),
                              ),
                            ),
                          ),
                          child: Text(
                            " ",
                            style: TextStyle(fontSize: 5),
                          ),
                        ),
                      ),
                    ];
                  }
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    Icon(Icons.error),
                  ];
                } else {
                  children = <Widget>[
                    Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ];
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                );
              }),
        ),
      ),
    );
  }
}
