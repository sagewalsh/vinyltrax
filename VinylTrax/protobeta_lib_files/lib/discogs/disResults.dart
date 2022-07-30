import 'package:flutter/material.dart';
import 'getDisArtist.dart';
import 'getDisAlbum.dart';
import 'getDisTracks.dart';
import '../pages/settingspage.dart' as settings;

class DisResults extends StatelessWidget {
  final String input;
  final String tab;
  DisResults(this.input, this.tab);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (settings.listBool) {
      if (tab == 'one')
        children.add(GetDisArtist(input));
      else if (tab == 'two')
        children.add(GetDisAlbum(input));
      else
        children.add(GetDisTracks(input));
    } else {
      children.add(GetDisArtist(input));
      children.add(GetDisAlbum(input));
      children.add(GetDisTracks(input));
    }

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 25,
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
