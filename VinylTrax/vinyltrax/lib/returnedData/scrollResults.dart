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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(widget.title, style: TextStyle(fontSize: 18))
              ),
              Spacer(),
              TextButton(
                  onPressed: () {
                    //go to a larger list of results
                  },
                  child: Text("See all")
              ),
            ],
          ),
          Divider(),
          Container(
            // height: MediaQuery.of(context).size.height * 0.24, //190
            height: MediaQuery.of(context).size.height * 0.25,
            // height: 190,
            child: ListView.separated(
              key: ObjectKey(widget.children[0]),
              itemCount: widget.children.length - 1,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.26,
                  width: MediaQuery.of(context).size.height * 0.26,
                  decoration: BoxDecoration(color: Color(0x20FF5A5A), borderRadius: BorderRadius.circular(20)),
                  child: Padding(padding: EdgeInsets.only(top: 6), child: widget.children[index])
                );
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
