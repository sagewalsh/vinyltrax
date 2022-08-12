import 'package:flutter/material.dart';
import 'package:googleapis/keep/v1.dart';
import '../buttons/pressDataPopUp.dart';
import 'database.dart';
import '../pages/settingspage.dart' as settings;

const Map<String, Color> colorOptions = {
  "Red": Colors.red,
  "Pink": Colors.pink,
  "Purple": Colors.purple,
  "Deep Purple": Colors.deepPurple,
  "Indigo": Colors.indigo,
  "Blue": Colors.blue,
  "Light Blue": Colors.lightBlue,
  "Cyan": Colors.cyan,
  "Teal": Colors.teal,
  "Green": Colors.green,
  "Light Green": Colors.lightGreen,
  "Lime": Colors.lime,
  "Yellow": Colors.yellow,
  "Amber": Colors.amber,
  "Orange": Colors.orange,
  "Deep Orange": Colors.deepOrange,
  "Brown": Colors.brown,
  "Grey": Colors.grey,
  "Blue Grey": Colors.blueGrey,
  "Black": Colors.black,
  "Other": Colors.black,
};

class GetInvPressing extends StatefulWidget {
  final List<String> input;

  GetInvPressing(this.input);

  @override
  State<GetInvPressing> createState() => _InvPress();
}

class _InvPress extends State<GetInvPressing> {
  Color backgroundColor = settings.darkTheme ? Colors.black : Colors.white;
  @override
  Widget build(BuildContext context) {
    Future<List<String>> _results = Database.getPressData(widget.input[0]);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: SizedBox(
      width: double.infinity,
      child: FutureBuilder<List<String>>(
        future: _results,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          List<Widget> children = <Widget>[];
          List<Widget> row = <Widget>[];

          if (snapshot.hasData && snapshot.data!.length > 0) {
            // Padding at the top
            children.add(SizedBox(
              width: double.infinity,
              height: 5,
              child: const Text(""),
            ));
            var data = snapshot.data!;

            String title = "";

            children.add(SizedBox(
              height: 20,
              width: width,
            ));

            /*
            #############################################
            Set Vinyl Color
            #############################################
            */
            Color color = settings.darkTheme ? Colors.white : Colors.black;
            if (data[1] != "") {
              title += "Color";
              color = colorOptions[data[1]]!;
              if (color == Colors.black && settings.darkTheme)
                backgroundColor = Color(0xFFBB86FC);
            }

            /*
            #############################################
            Set Number of LPs
            #############################################
            */
            if (data[0] != "") {
              if (title.isEmpty)
                title = "Qty.";
              else
                title += " & Qty.";

              if (data[0] == "4+") data[0] = "4";
              List<Widget> number = <Widget>[];
              for (int i = 0; i < int.parse(data[0]); i++) {
                if (i == 0) {
                  number += [
                    Image.asset(
                      "assets/vinyl-box.png",
                      // width: width * 0.30 / int.parse(data[0]),
                      height: width * .15,
                      color: color,
                    )
                  ];
                } else
                  number += [
                    Image.asset(
                      "assets/vinyl-lp.png",
                      height: width * .08,
                      color: color,
                    )
                  ];
              }

              /*
              #############################################
              Add Vinyl Box
              #############################################
              */
              row.add(Column(
                children: [
                  Text(title,
                      style: TextStyle(
                          color: settings.darkTheme
                              ? Colors.white
                              : Colors.black)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: backgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: width * 0.2,
                        width: width * 0.4,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: number,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            } else if (data[1] != "") {
              row.add(Column(
                children: [
                  Text(title,
                      style: TextStyle(
                          color: settings.darkTheme
                              ? Colors.white
                              : Colors.black)),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: width * 0.2,
                        width: width * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/vinyl-box.png",
                              height: width * .15,
                              color: color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            }
            if (data[3] != "") {
              /*
              #############################################
              Add Year
              #############################################
              */
              row.add(Column(
                children: [
                  Text("Year",
                      style: TextStyle(
                          color: settings.darkTheme
                              ? Colors.white
                              : Colors.black)),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: width * 0.2,
                        width: width * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data[3],
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: settings.darkTheme
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            }

            if (row.isNotEmpty) {
              children += [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row,
                ),
                SizedBox(height: 10),
              ];
            }

            /*
            #############################################
            Add LP Size
            #############################################
            */
            if (data[2] != "") {
              // Color of highlighted LP size
              if (color == Colors.black || color == Colors.white)
                color =
                    settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A);
              List<Color> colors = [
                settings.darkTheme ? Colors.white : Colors.black,
                settings.darkTheme ? Colors.white : Colors.black,
                settings.darkTheme ? Colors.white : Colors.black
              ];
              if (data[2] == "33")
                colors[0] = color;
              else if (data[2] == "45")
                colors[2] = color;
              else if (data[2] == "78") colors[1] = color;

              children.add(Text("Size",
                  style: TextStyle(
                      color:
                          settings.darkTheme ? Colors.white : Colors.black)));
              children.add(Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: width * 0.33,
                    width: width * .76 + 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/vinyl-lp.png",
                              width: width * 0.25,
                              color: colors[0],
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Image.asset(
                              "assets/vinyl-lp.png",
                              width: width * 0.20,
                              color: colors[1],
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Image.asset(
                              "assets/vinyl-lp.png",
                              width: width * 0.15,
                              color: colors[2],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
            }

            /*
            #############################################
            Add Manufacturer
            #############################################
            */
            if (data[4] != "") {
              if (children.length > 2)
                children.add(SizedBox(
                  height: 20,
                  width: width,
                ));
              children.add(Text("Manufacturer",
                  style: TextStyle(
                      color:
                          settings.darkTheme ? Colors.white : Colors.black)));
              children.add(Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    width: width * 0.76 + 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data[4],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: settings.darkTheme
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
            }
          } else
            children.add(SizedBox(
              width: double.infinity,
              height: 20,
              child: const Text(""),
            ));

          return GestureDetector(
            onTap: () {
              // print("this works");
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PressDataPopUp(widget.input);
                  });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: settings.darkTheme
                            ? Colors.black
                            : Color(0xFFFFFDF6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: children.length > 2
                                ? settings.darkTheme
                                    ? Color(0xFFBB86FC)
                                    : Color(0xFFFF5A5A)
                                : settings.darkTheme
                                    ? Colors.white
                                    : Colors.black)),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pressing Data",
                            style: TextStyle(
                              color: children.length > 2
                                  ? settings.darkTheme
                                      ? Color(0xFFBB86FC)
                                      : Color(0xFFFF5A5A)
                                  : settings.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Spacing after the Pressing Data
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: const Text(""),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
