import 'package:flutter/material.dart';

class ListEntry extends StatelessWidget {
  final String name;
  final String image;
  final bool isAlbum;
  Color? color = null;
  //const ShowListEntry({Key? key}) : super(key: key);

  ListEntry(this.name, this.image, this.isAlbum);

  @override
  Widget build(BuildContext context) {
    Widget avatar = SizedBox();
    if (!isAlbum) {
      avatar = CircleAvatar(
        foregroundImage: NetworkImage(
            "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg"
        )
      );
    }
    else {
      avatar = Container(
        height: 40,
        width: 40,
        child: Image(
          image: NetworkImage(
              "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg"
          ),
        ),
      );
    }

    return ListTile(
      tileColor: color,
      leading: avatar,
      title: Text(name),
      onTap: () {
        print(name);
      },
    );
  }
}
