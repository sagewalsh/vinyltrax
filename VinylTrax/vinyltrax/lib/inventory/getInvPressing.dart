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
  @override
  Widget build(BuildContext context) {
    Future<List<String>> _results = Database.getPressData(widget.input[0]);

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

            Color color = Colors.black;
            // Color of LPs
            if (data[1] != "") {
              title += "Color";
              // // Set color based on input
              // if (data[1] == "Other")
              //   color = Colors.purple;
              // else if (data[1] == "Blue")
              //   color = Colors.blue;
              // else if (data[1] == "Red")
              //   color = Colors.red;
              // else if (data[1] == "Yellow") color = Colors.yellow;
              color = colorOptions[data[1]]!;
            }

            // Number of LPs
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
                      width: MediaQuery.of(context).size.width *
                          0.30 /
                          int.parse(data[0]),
                      color: color,
                    )
                  ];
                } else
                  number += [
                    Image.asset(
                      "assets/vinyl-lp.png",
                      width: MediaQuery.of(context).size.width *
                          0.20 /
                          int.parse(data[0]),
                      color: color,
                    )
                  ];
              }
              row.add(Column(
                children: [
                  Text(title),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 4,
                        color: settings.darkTheme
                            ? Color(0xFFBB86FC)
                            : Color(0xFFFF5A5A),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.33,
                        width: MediaQuery.of(context).size.width * 0.33,
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
              // Add colored vinyl icon
              row.add(Column(
                children: [
                  Text(title),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 4,
                        color: settings.darkTheme
                            ? Color(0xFFBB86FC)
                            : Color(0xFFFF5A5A),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.33,
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/vinyl-box.png",
                              width: MediaQuery.of(context).size.width * 0.20,
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
              if (row.isNotEmpty) {
                row.add(SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ));
              }
              row.add(Column(
                children: [
                  Text("Year"),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 4,
                        color: settings.darkTheme
                            ? Color(0xFFBB86FC)
                            : Color(0xFFFF5A5A),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.33,
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data[3],
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
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
                SizedBox(height: MediaQuery.of(context).size.width * .10),
              ];
            }

            // Size of LP
            if (data[2] != "") {
              // Color of highlighted LP size
              if (color == Colors.black)
                color =
                    settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A);
              List<Color> colors = [Colors.black, Colors.black, Colors.black];
              if (data[2] == "33")
                colors = [color, Colors.black, Colors.black];
              else if (data[2] == "45")
                colors = [Colors.black, Colors.black, color];
              else if (data[2] == "78")
                colors = [Colors.black, color, Colors.black];

              children.add(Text("Size"));
              children.add(Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 4,
                    color: settings.darkTheme
                        ? Color(0xFFBB86FC)
                        : Color(0xFFFF5A5A),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.33,
                    width: MediaQuery.of(context).size.width * .76 + 16,
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
                              width: MediaQuery.of(context).size.width * 0.25,
                              color: colors[0],
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Image.asset(
                              "assets/vinyl-lp.png",
                              width: MediaQuery.of(context).size.width * 0.20,
                              color: colors[1],
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Image.asset(
                              "assets/vinyl-lp.png",
                              width: MediaQuery.of(context).size.width * 0.15,
                              color: colors[2],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
              children.add(
                  SizedBox(height: MediaQuery.of(context).size.width * .10));
            }
            if (data[4] != "") {
              children.add(Text("Manufacturer"));
              children.add(Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 4,
                    color: settings.darkTheme
                        ? Color(0xFFBB86FC)
                        : Color(0xFFFF5A5A),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.33,
                    width: MediaQuery.of(context).size.width * 0.76 + 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data[4],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                    return PressDataPopUp(widget.input[0]);
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
                        color: settings.darkTheme ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 0,
                          color:
                              settings.darkTheme ? Colors.black : Colors.white,
                        )),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pressing Data",
                            style: TextStyle(
                              color: settings.darkTheme
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
