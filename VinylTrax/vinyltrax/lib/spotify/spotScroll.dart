import 'package:flutter/material.dart';
import 'package:vinyltrax/spotify/spotAllButton.dart';
import '../pages/settingspage.dart' as settings;

class SpotScroll extends StatefulWidget {
  //const ScrollResults({Key? key}) : super(key: key);
  List<Widget> children = [];
  final String title;
  final AsyncSnapshot<Map<String, List<dynamic>>> snapshot;

  SpotScroll(this.children, this.title, this.snapshot);

  @override
  State<SpotScroll> createState() => _SpotScrollState();
}

class _SpotScrollState extends State<SpotScroll> {
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
                  child: Text(widget.title, style: TextStyle(fontSize: 18))),
              Spacer(),
              TextButton(
                  onPressed: () {
                    //go to a larger list of results
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => SpotAllButton(
                              widget.snapshot,
                              widget.title,
                            ));
                    Navigator.of(context).push(route);
                  },
                  child: Text("See all")),
            ],
          ),
          Divider(),
          Container(
            // height: MediaQuery.of(context).size.height * 0.24, //190
            height: MediaQuery.of(context).size.height * 0.25,
            // height: 190,
            child: ListView.separated(
              key: ObjectKey(widget.children[0]),
              itemCount: widget.children.length,
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.26,
                    width: MediaQuery.of(context).size.height * 0.26,
                    decoration: BoxDecoration(
                        color: settings.darkTheme ? Color(0x20BB86FC) : Color(0x20FF5A5A),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: widget.children[index]));
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
