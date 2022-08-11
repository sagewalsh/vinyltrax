import 'package:flutter/material.dart';
import 'package:vinyltrax/pages/staxpage.dart';
import 'package:vinyltrax/inventory/database.dart';
import 'package:vinyltrax/inventory/getInvCategories.dart';
import 'package:vinyltrax/pages/settingspage.dart' as settings;

class Categories extends StatefulWidget {
  final Type input;
  late String format;

  Categories(this.input) {
    if (input == Type.vinyl)
      format = "Vinyl";
    else if (input == Type.cd)
      format = "CD";
    else
      format = "All";
  }

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<List<String>> _results = Database.getCategories();
  List<Widget> children = [];
  TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        child: FutureBuilder<List<String>>(
            future: _results,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                children = <Widget>[];
                var data = snapshot.data!;
                if (data.length != 0) {
                  data.forEach((category) {
                    children.add(CategoryTile(category, widget.format));
                  });
                }
                children.add(SizedBox(height: 15));
                children.add(Center(
                  child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(hintText: "Enter Category Name"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Database.createCategory(_controller.text);
                                            Navigator.pushNamed(context, 'inven');
                                          },
                                          child: Text("Confirm")
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel")
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .8,
                            height: MediaQuery.of(context).size.height * .05,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: settings.darkTheme
                                      ? Color(0xFFBB86FC)
                                      : Color(0xFFFF5A5A),
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                                  "Add Category",
                                  style: TextStyle(
                                      color: settings.darkTheme
                                          ? Color(0xFFBB86FC)
                                          : Color(0xFFFF5A5A)),
                                )),
                          )),
                ));
              } else if (snapshot.hasError) {
                children = [
                  Icon(Icons.error),
                ];
              } else {
                children = [
                  Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ];
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              );
            }),
      ),
    );
  }
}

/*
#############################################################################
CATEGORY TILE CLASS
#############################################################################
*/
class CategoryTile extends StatelessWidget {
  final String title;
  final String format;

  CategoryTile(this.title, this.format) {}

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
      /*
      Category Name
      */
      title: Container(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: settings.darkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),

      /*
      Underline
      */
      subtitle: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: settings.darkTheme ? Color(0x64BB86FC) : Color(0x64FF5A5A),
              // color: Color.fromARGB(0, 255, 90, 90),
            ),
          ),
        ),
        child: Text(
          " ",
          style: TextStyle(fontSize: 5),
        ),
      ),

      /*
      Ending Space
      */
      trailing: Container(
        width: 25,
        child: Text(""),
      ),
      visualDensity: VisualDensity(vertical: -3),
      onTap: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new NextPage(title, format));
        Navigator.of(context).push(route);
      },
    );
  }
}

class NextPage extends StatefulWidget {
  final String title;
  final String format;

  NextPage(this.title, this.format);
  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor:
          settings.darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
      appBar: new AppBar(
        backgroundColor:
            settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
        leading: BackButton(
          color: settings.darkTheme ? Colors.white : Colors.black,
        ),
        title: Text(
          widget.title,
          style: TextStyle(
              color: settings.darkTheme ? Colors.white : Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            Space before the list
            */
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.0372,
            ),

            /*
            Get categorized albums from inventory
            */
            GetInvCategories(widget.title, widget.format),

            /*
            Space after the list
            */
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.0372,
            )
          ],
        ),
      ),
    );
  }
}
