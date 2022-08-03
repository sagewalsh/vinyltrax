import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vinyltrax/main.dart';
import 'package:vinyltrax/pages/newAccountPage.dart';
import 'package:vinyltrax/pages/staxpage.dart';
import '../auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double opacity = 0.0;
  bool move = false;
  double visible = 0;
  String username = "";
  String password = "";

  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      opacity = 1;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        move = true;
        visible = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focus = FocusNode();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFDF6),
        body: Stack(alignment: AlignmentDirectional.centerStart, children: [
          AnimatedPositioned(
            left: width * .25,
            top: move ? height * .25 : height * .45,
            duration: Duration(seconds: 1),
            child: AnimatedOpacity(
              opacity: opacity,
              duration: Duration(seconds: 1),
              child:
                  Text("Vinyl Trax", style: GoogleFonts.orbitron(fontSize: 30)),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            bottom: move ? 0 : (height - width) / 2,
            child: Image.asset(
              "assets/logo/newLogo2.png",
              color: move
                  ? Color.fromARGB(30, 255, 90, 90)
                  : Color.fromARGB(255, 255, 90, 90),
              // height: move ? width : height * .4,
              height: width,
            ),
          ),
          Positioned(
              left: width * .19,
              //left: MediaQuery.of(context).size.width * .27,
              top: height * .35,
              child: AnimatedOpacity(
                duration: Duration(seconds: 2),
                opacity: visible,
                child: Column(
                  children: [
                    Container(
                      width: width * .63,
                      height: height * .063,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: "Username",
                          hintStyle: TextStyle(
                            color: Color(0xFFFF5A5A),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Color(0xFFFF5A5A),
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.account_circle,
                            color: focus.hasFocus
                                ? Color(0xFFFF5A5A)
                                : Colors.black,
                          ),
                        ),
                        onChanged: (String value) {
                          username = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: width * .63,
                      height: height * .063,
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Color(0xFFFF5A5A),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Color(0xFFFF5A5A),
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.password,
                            color: focus.hasFocus
                                ? Color(0xFFFF5A5A)
                                : Colors.black,
                          ),
                        ),
                        onChanged: (String value) {
                          password = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        //Sign in code here
                        Authentication.signIn(username, password)
                            .then((success) {
                          if (success) Navigator.pushNamed(context, 'inven');
                        });
                      },
                      child: Text("Sign In"),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFFFF5A5A)),
                    ),
                    SizedBox(height: 15),
                    RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0),
                            children: [
                          TextSpan(text: "Don't have an account? "),
                          TextSpan(
                              text: "Sign up here",
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  var route = new MaterialPageRoute(
                                      builder: (BuildContext) =>
                                          NewAccountPage());
                                  Navigator.of(context).push(route);
                                }),
                        ])),
                    SizedBox(height: 15),
                    RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.blue, fontSize: 14.0),
                            children: [
                          TextSpan(
                              text: "Click here for testers",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, 'inven');
                                })
                        ])),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
