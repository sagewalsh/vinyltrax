import 'package:flutter/material.dart';
import '../returnedData/byGenre.dart';

class GenreTile extends StatelessWidget {
  final String genreName;
  final bool isEven;
  //const GenreTile({Key? key}) : super(key: key);

  GenreTile(this.genreName, this.isEven);

  @override
  Widget build(BuildContext context) {
    Color? color = Colors.white;
    if (isEven) color = Colors.black12;

    return ListTile(
      title: Text(genreName),
      tileColor: color,
      visualDensity: VisualDensity(vertical: -3),
      onTap: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new NextPage(genreName));
        Navigator.of(context).push(route);
      },
    );
  }
}

class NextPage extends StatefulWidget {
  final String genreName;
  //NextPage({Key? key, this.genreName}) : super(key: key);

  NextPage(this.genreName);
  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  String get genreName => this.genreName;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("${widget.genreName}"),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 30,
                child: Text(""),
              ),
              AlbumsOfGenre("${widget.genreName}"),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: Text(""),
              ),
            ],
          ),
        ));
  }
}
