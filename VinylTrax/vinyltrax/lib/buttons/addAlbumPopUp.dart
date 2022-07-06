import 'package:flutter/material.dart';

class AddAlbumPopUp extends StatefulWidget {
  String artist = "";
  String album = "";

  //const AddAlbumPopUp({Key? key}) : super(key: key);

  AddAlbumPopUp(this.artist, this.album);

  @override
  State<AddAlbumPopUp> createState() => _AddAlbumPopUpState();
}

class _AddAlbumPopUpState extends State<AddAlbumPopUp> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
