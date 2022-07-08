import 'package:flutter/material.dart';

class ScrollResults extends StatefulWidget {
  //const ScrollResults({Key? key}) : super(key: key);
  List<Widget> children = [];
  String title = "";
  ScrollResults(this.children, this.title);

  @override
  State<ScrollResults> createState() => _ScrollResultsState();
}

class _ScrollResultsState extends State<ScrollResults> {
  List<Widget> output = [];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.children.length; i++) {
      output.add(widget.children[i]);
      output.add(SizedBox(width: 10));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(8, 15, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: TextStyle(fontSize: 18)),
          Divider(),
          Container(
            height: 190,
            child: ListView.separated(
                itemCount: widget.children.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return widget.children[index];
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 15);
                },
            ),
          ),
        ],
      ),
    );
  }
}
