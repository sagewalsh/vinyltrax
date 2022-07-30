import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/icon.dart';
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
          Divider(color: Color(0x64FF5A5A),),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(widget.title, style: TextStyle(fontSize: 18,
                      color: settings.darkTheme ? Colors.white : Colors.black))),
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
                  child: Text("See all", 
                  style: TextStyle(color: Color(0xFFFF5A5A)),)),
            ],
          ),
          Container(
            // height: MediaQuery.of(context).size.height * 0.24, //190
            height: (MediaQuery.of(context).size.height * 0.18 +  MediaQuery.of(context).size.height * .0262 +  MediaQuery.of(context).size.height * .0262 + 24),
            // height: 190,
            child: ListView.separated(
              key: ObjectKey(widget.children[0]),
              itemCount: widget.children.length,
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var ic = widget.children[index] as ShowIcon;
                if(ic.isArtist){
                  return Container(
                    height: (MediaQuery.of(context).size.height * 0.18 +  MediaQuery.of(context).size.height * .0262  + 24),
                      decoration: BoxDecoration(
                          color: settings.darkTheme ? Color(0x20C9C9C9) : Color(0xFFFFFDF6),
                          borderRadius: BorderRadius.circular(20),
                      //     border: Border.all(
                      //       color: settings.darkTheme
                      // ? Color(0xFFBB86FC)
                      // : Color(0xFFFF5A5A),
                      // width: 1,
                      //     )
                          ),
                      child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    child: widget.children[index]),
                            ],
                          ),
                      );
                } else{
                    return Container(
                      height: (MediaQuery.of(context).size.height * 0.18 +  MediaQuery.of(context).size.height * .0262 +  MediaQuery.of(context).size.height * .0262 + 24),
                    decoration: BoxDecoration(
                        color: settings.darkTheme ? Color(0x20C9C9C9) : Color(0xFFFFFDF6),
                        borderRadius: BorderRadius.circular(20)),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: widget.children[index]),
                      ],
                    ),
                    );
                  }
              },
              separatorBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    // Container(
                    //   height: (MediaQuery.of(context).size.height * 0.18 ),
                    //   decoration: BoxDecoration(
                    //     border: Border(right: BorderSide(width: 1, color: Color(0xFFFF5A5A)))
                    //   ),
                    //   child: SizedBox(
                    //       width: MediaQuery.of(context).size.width * 0.019),
                    // ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.038),
                  ],
                ); //15
              },
            ),
          ),
        ],
      ),
    );
  }
}
