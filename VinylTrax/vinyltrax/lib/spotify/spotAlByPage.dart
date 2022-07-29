import 'package:flutter/cupertino.dart';
import 'spotAlbumsBy.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import 'package:vinyltrax/show_data/listEntryList.dart';
import '../show_data/icon.dart';
import 'spotify.dart';
import '../pages/settingspage.dart' as settings;
import '../show_data/listEntry.dart';
import 'spotScroll.dart';

import 'dart:developer';

class SpotAlByPage extends StatefulWidget {
  final List<String> input;
  SpotAlByPage(this.input);

  @override
  State<SpotAlByPage> createState() => _SpotAlByPage();
}

enum _Tab { one, two, three }

class _SpotAlByPage extends State<SpotAlByPage> {
  _Tab _selectedTab = _Tab.one;
  Widget output = SizedBox();

  Widget AddFilterButtons(List<String> text) {
    if (settings.listBool) {
      return Container(
        //Icon/List buttons and Top/Artist/Album/Song buttons
        color: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
        padding: EdgeInsets.only(bottom: 5, top: 10),
        child: SizedBox(
          height: 30,
          child: CupertinoSegmentedControl(
            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            selectedColor:
                settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
            borderColor:
                settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
            pressedColor:
                settings.darkTheme ? Color(0x64BB86FC) : Color(0x64FF5A5A),
            children: {
              _Tab.one: Container(
                height: 30,
                width: 85,
                child: Center(
                  child: Text("Albums", style: TextStyle(fontSize: 14)),
                ),
              ),
              _Tab.two: Container(
                height: 30,
                width: 85,
                child: Center(
                  child: Text("EPs", style: TextStyle(fontSize: 14)),
                ),
              ),
              _Tab.three: Container(
                height: 30,
                width: 85,
                child: Center(
                  child: Text("Featured", style: TextStyle(fontSize: 14)),
                ),
              ),
            },
            onValueChanged: (value) {
              setState(() {
                _selectedTab = value as _Tab;
                output = SpotAlbumsBy(text, _selectedTab.name);
              });
            },
            groupValue: _selectedTab,
          ),
        ),
      );
    } else
      return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    double toolbarHeight;
    if (settings.listBool)
      toolbarHeight = MediaQuery.of(context).size.height * 0.15;
    else
      toolbarHeight = MediaQuery.of(context).size.height * 0.10;

    output = SpotAlbumsBy(widget.input, _selectedTab.name);
    return SafeArea(
        child: Scaffold(
      backgroundColor:
          settings.darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
      appBar: AppBar(
        toolbarHeight: toolbarHeight, //180
        backgroundColor:
            settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
        leading: BackButton(
          color: settings.darkTheme ? Colors.white : Colors.black,
        ),
        title: Column(
          children: [
            Text(
              widget.input[1],
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            AddFilterButtons(widget.input),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: settings.darkTheme
                  ? [Color(0xFF181818), Color(0xFF222222)]
                  : [Color(0xFFFFFDF6), Color(0xFFFFFDF6)]),
        ),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Divider between UI and output
              Container(
                color:
                    settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
                height: 5,
              ),
              output
            ],
          ),
        ),
      ),
    ));
  }
}
