import 'package:flutter/material.dart';

class ShowListEntry extends StatelessWidget {
  final String name;
  final String image;
  final Color? color;
  //const ShowListEntry({Key? key}) : super(key: key);

  ShowListEntry(this.name, this.image, this.color);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color,
      leading: CircleAvatar(
        foregroundImage: NetworkImage(
            "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg"
        ),
      ),
      title: Text("test"),
    );
  }
}
