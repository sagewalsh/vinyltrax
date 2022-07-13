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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.02, //8
          MediaQuery.of(context).size.height * 0.0186, //15
          MediaQuery.of(context).size.width * 0.02, //8
          0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(widget.title, style: TextStyle(fontSize: 18))),
          Divider(),
          Container(
            // height: MediaQuery.of(context).size.height * 0.24, //190
            height: MediaQuery.of(context).size.height * 0.27,
            // height: 190,
            child: ListView.separated(
              key: ObjectKey(widget.children[0]),
              itemCount: widget.children.length - 1,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return widget.children[index];
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.038); //15
              },
            ),
          ),
        ],
      ),
    );
  }
}
