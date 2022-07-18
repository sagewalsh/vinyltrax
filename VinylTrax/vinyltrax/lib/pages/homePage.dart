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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFDF6),
        body: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            AnimatedPositioned(
              left: MediaQuery.of(context).size.width * .28,
              top: move ? MediaQuery.of(context).size.height * .25 : MediaQuery.of(context).size.height * .45,
              duration: Duration(seconds: 1),
              child: AnimatedOpacity(
                opacity: opacity,
                duration: Duration(seconds: 1),
                child: Text("Vinyl Trax", style: GoogleFonts.orbitron(fontSize: 30)),
              ),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width * .35,
                top: MediaQuery.of(context).size.height * .35,
                child: AnimatedOpacity(
                  duration: Duration(seconds: 3),
                  opacity: visible,
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'inven');
                          },
                          child: Text("See Inventory")
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'search');
                          },
                          child: Text("Start Search")
                      ),
                    ],
            ),
                ))
          ]
        ),
      ),
    );
  }
}
