import 'package:flutter/material.dart';
import '../buttons/pressDataPopUp.dart';
import '../database.dart';

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
          children.add(Text(
            "Pressing Data",
            style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
            ),
          ));
          if (snapshot.hasData && snapshot.data!.length > 0) {
            children.add(SizedBox(
              width: double.infinity,
              height: 5,
              child: const Text(""),
            ));
            var data = snapshot.data!;
            if (data[0] != "") {
              children.add(Text(
                "Number of LPs:\t" + data[0],
                style: TextStyle(),
              ));
            }
            if (data[1] != "") {
              children.add(Text(
                "Color of LPs:\t" + data[1],
                style: TextStyle(),
              ));
            }
            if (data[2] != "") {
              children.add(Text(
                "RPM Size:\t" + data[2],
                style: TextStyle(),
              ));
            }
            if (data[3] != "") {
              children.add(Text(
                "Year:\t" + data[3],
                style: TextStyle(),
              ));
            }
            if (data[4] != "") {
              children.add(Text(
                "Manufacturer:\t" + data[4],
                style: TextStyle(),
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
              print("this works");
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PressDataPopUp();
                  }
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFFF5A5A),
                        )),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children,
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
