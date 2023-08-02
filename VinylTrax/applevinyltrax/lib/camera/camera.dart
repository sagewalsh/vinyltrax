import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:applevinyltrax/camera/cameraResults.dart';
import 'package:applevinyltrax/spotify/spotifyResults.dart';
import 'dart:typed_data';

import 'coverscan.dart';

class Camera extends StatefulWidget {
  final CameraDescription camera;
  const Camera(this.camera);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;
  XFile? pictureFile;
  IconData flashIcon = Icons.flash_auto;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    imageCache.clearLiveImages();
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _controller.setFlashMode(FlashMode.auto);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getImageDetails(String filePath) async {
    final image = vision.Image(content: filePath);
    print(image);
  }

  String results = "";
  List<String> censoredWords = [
    'album',
    'cover',
    'vinyl',
    '[vinyl]',
    'usa',
    'import',
    'lp',
    '[lp]',
    'cd',
    '[cd]',
    'soundtrack',
    '(album)',
    '[german import]',
    'art',
    'poster'
  ];
  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
              child: Text('Take a picture',
                  style: TextStyle(color: Colors.white))),
          backgroundColor: Colors.black,
        ),
        body: const SizedBox(
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child:
                Text('Take a picture', style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.black,
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Column(
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .70,
              width: MediaQuery.of(context).size.width,
              child: CameraPreview(_controller),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'search');
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.white))),
              IconButton(
                  constraints: BoxConstraints(minHeight: 100, minWidth: 100),
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    pictureFile = await _controller.takePicture();
                    Uint8List byteData =
                        Uint8List.fromList([10, 1]); //placeholder

                    await pictureFile!.readAsBytes().then((value) {
                      setState(() {
                        byteData = value;
                      });
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Scanning Photo..."),
                          );
                        });

                    String base64Image = await base64Encode(byteData);
                    Future<String> test = CoverScan.getOptions(base64Image);

                    await test.then((value) {
                      setState(() {
                        results = value;
                        for (int i = 0; i < censoredWords.length; i++) {
                          results = results.replaceAll(censoredWords[i], "");
                        }
                      });
                    });
                    var route =
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new CameraResults(results);
                    });
                    Navigator.of(context).push(route);
                  },
                  icon: Icon(Icons.camera,
                      size: MediaQuery.of(context).size.width * .2,
                      color: Colors.white)),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (flashIcon == Icons.flash_off) {
                      _controller.setFlashMode(FlashMode.auto);
                      setState(() {
                        flashIcon = Icons.flash_auto;
                      });
                    } else if (flashIcon == Icons.flash_auto) {
                      _controller.setFlashMode(FlashMode.always);
                      setState(() {
                        flashIcon = Icons.flash_on;
                      });
                    } else {
                      _controller.setFlashMode(FlashMode.off);
                      setState(() {
                        flashIcon = Icons.flash_off;
                      });
                    }
                  },
                  icon: Icon(
                    flashIcon,
                    size: MediaQuery.of(context).size.width * .1,
                    color: Colors.white,
                  )),
            ],
          ),
          //Underneath I have it so the pictureFile!.path will give the correct file path
        ],
      ),
    );
  }
}
