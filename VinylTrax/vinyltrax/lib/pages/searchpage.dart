import 'package:flutter/material.dart';
import 'package:vinyltrax/fliterButtons.dart';
import 'package:firebase_database/firebase_database.dart';
import '../textinput.dart';
import '../iconOrList.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                child: TextInput("Search"),
                color: Color.fromARGB(255, 244, 244, 244)),
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
    );
  }
}
