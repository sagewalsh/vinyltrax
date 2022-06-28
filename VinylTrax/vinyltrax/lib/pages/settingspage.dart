import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text("Settings Page"),
        ),
      ),
    );
  }
}
