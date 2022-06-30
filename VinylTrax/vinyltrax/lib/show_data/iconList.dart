import 'package:flutter/material.dart';

import 'icon.dart';

class IconList extends StatelessWidget {
  const IconList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 30,
          runSpacing: 20,
          children: [
            ShowIcon("art1", "alb1", "", true),
            ShowIcon("art2", "alb2", "", true),
            ShowIcon("art3", "alb3", "", false),
            ShowIcon("art4", "alb4", "", true),
            ShowIcon("art5", "alb5", "", true),
            ShowIcon("art6", "alb6", "", false),
            ShowIcon("art7", "alb7", "", false),
          ],
        ),
      ),
    );
  }
}
