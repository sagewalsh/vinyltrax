import 'package:flutter/material.dart';
import '../inventory/getInvGenre.dart';

class GenreTile extends StatelessWidget {
  final String genreName;
  // final bool isEven;
  final String format;
  final String icon;
  //const GenreTile({Key? key}) : super(key: key);

  GenreTile(this.genreName, this.format, this.icon);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Color(0xFFFFFEF9),
      // Genre Icon
      leading: Container(
        padding: EdgeInsets.all(10),
        child: Image.asset(
          icon,
          width: 25,
          // color: Color.fromARGB(86, 255, 90, 90),
        ),
      ),

      // Genre Title
      title: Container(
        child: Text(
          genreName,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),

      // Underline
      subtitle: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color.fromARGB(86, 255, 90, 90),
              // color: Color.fromARGB(0, 255, 90, 90),
            ),
          ),
        ),
        child: Text(
          " ",
          style: TextStyle(fontSize: 5),
        ),
      ),

      // Ending Space
      trailing: Container(
        // padding: EdgeInsets.all(10),
        child: Image.asset(
          icon,
          width: 25,
          color: Color.fromARGB(0, 0, 0, 0),
        ),
      ),

      visualDensity: VisualDensity(vertical: -3),
      onTap: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new NextPage(genreName, format));
        Navigator.of(context).push(route);
      },
    );
  }
}

class NextPage extends StatefulWidget {
  final String genreName;
  final String format;
  //NextPage({Key? key, this.genreName}) : super(key: key);

  NextPage(this.genreName, this.format);
  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  String get genreName => this.genreName;
  String get format => this.format;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xFFFFFEF9),
        appBar: new AppBar(
          backgroundColor: Color(0xFFFFFEF9),
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            "${widget.genreName}",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.0372,
              ),

              // Get data from database
              GetInvGenre("${widget.genreName}", "${widget.format}"),

              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.0372,
              ),
            ],
          ),
        ));
  }
}
