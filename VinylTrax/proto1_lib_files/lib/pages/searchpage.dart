import 'package:flutter/material.dart';
import 'package:vinyltrax/fliterButtons.dart';
import '../textinput.dart';
import '../iconOrList.dart';
import './searchresultspage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textBox = TextInput("Search");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(30, 0, 105, 1),
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text("Search Page"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: textBox,
              width: double.infinity,
              height: 75,
            ),
            Container(
              color: Color.fromARGB(255, 244, 244, 244),
              child: Row(
                children: [
                  iconOrList(),
                  SizedBox(width: 5),
                  filterButtons(),
                ],
              ),
            ),
            Container(color: Color.fromARGB(255, 244, 244, 244), height: 5),
            Divider(
              color: Colors.grey[400],
              height: 5,
              thickness: .5,
              indent: 8,
              endIndent: 8,
            ),
          ],
        ),
      ),
/*
###############################################################################
To Be Removed Later
###############################################################################
*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            var id = 0;
            try {
              id = int.parse(textBox.getString());
            } catch (exception) {}
            return SearchResultsPage(id.toString());
          }));
        },
        child: const Icon(Icons.search),
      ),
/*
###############################################################################
*/
    );
  }
}
