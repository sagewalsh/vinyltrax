import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double opacity = 0.0;
  bool move = false;
  double visible = 0;

  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      opacity = 1;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState((){
        move = true;
        visible = 1;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    FocusNode focus = FocusNode();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFDF6),
        body: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            AnimatedPositioned(
              left: MediaQuery.of(context).size.width * .27,
              top: move ? MediaQuery.of(context).size.height * .25 : MediaQuery.of(context).size.height * .45,
              duration: Duration(seconds: 1),
              child: AnimatedOpacity(
                opacity: opacity,
                duration: Duration(seconds: 1),
                child: Text("Vinyl Trax", style: GoogleFonts.orbitron(fontSize: 30)),
              ),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width * .19,
                //left: MediaQuery.of(context).size.width * .27,
                top: MediaQuery.of(context).size.height * .35,
                child: AnimatedOpacity(
                  duration: Duration(seconds: 3),
                  opacity: visible,
                  child: Column(
                    children: [
                      // ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.pushNamed(context, 'inven');
                      //     },
                      //     child: Text("See Inventory")
                      // ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.pushNamed(context, 'search');
                      //     },
                      //     child: Text("Start Search")
                      // ),
                      Container(
                        width: 250,
                        height: 50,
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
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 250,
                        height: 50,
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
                        ),
                      ),
                      SizedBox(height: 15),
                      RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 14.0),
                            children: [
                              TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: "Sign up here",
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print("new account!");
                                  }
                              ),
                            ]
                          )
                      ),
                    ],
                   ),
                )
            ),
            Positioned(
              top: 600,
                child: Image.asset(
                  "assets/vinyl-record.png",
                  width: MediaQuery.of(context).size.width,
                )
            ),
          ]
        ),
      ),
    );
  }
}
