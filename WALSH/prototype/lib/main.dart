import 'package:flutter/material.dart';
import './tabs.dart';

void main() => runApp(const VinylTrax());

class VinylTrax extends StatelessWidget {
  const VinylTrax({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Tabs());
  }
}
