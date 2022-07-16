import 'package:flutter/material.dart';
import '../returnedData/getInvGenre.dart';

class GenreTile extends StatelessWidget {
  final String genreName;
  final bool isEven;
  final String format;
  //const GenreTile({Key? key}) : super(key: key);

  GenreTile(this.genreName, this.isEven, this.format);

  @override
  Widget build(BuildContext context) {
    Color? color = Colors.white;
    if (isEven) color = Color(0x20FF5A5A);

    return ListTile(
      title: Text(genreName),
      tileColor: color,
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
