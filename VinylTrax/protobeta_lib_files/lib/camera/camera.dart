import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vinyltrax/camera/cameraResults.dart';
import 'package:vinyltrax/spotify/spotifyResults.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {return;}
      setState((){});
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
        backgroundColor: Color(0xFFFFFEF9),
        appBar: AppBar(
          title: const Text('Take a picture', style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xFFFFFEF9),
          leading: BackButton(color: Colors.black),
        ),
        body: const SizedBox(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFFEF9),
      appBar: AppBar(
          title: const Text('Take a picture', style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xFFFFFEF9),
          leading: BackButton(color: Colors.black),
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: CameraPreview(_controller),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () async {
                pictureFile = await _controller.takePicture();
                Uint8List byteData = Uint8List.fromList([10, 1]); //placeholder

                await pictureFile!.readAsBytes().then((value) {
                  setState((){
                    byteData = value;
                  });
                });
                String base64Image = await base64Encode(byteData);
                Future<String> test = CoverScan.getOptions(base64Image);

                await test.then((value){
                  setState((){
                    results = value;
                    for (int i = 0; i < censoredWords.length; i++) {
                      results = results.replaceAll(censoredWords[i], "");
                    }
                  });
                });
                var route = new MaterialPageRoute(builder: (BuildContext context) {
                  return new CameraResults(results);
                });
                Navigator.of(context).push(route);
              },
              child: Text("Take Picture"),
            ),
          ),
          //Underneath I have it so the pictureFile!.path will give the correct file path
        ],
      ),

    );
  }
}
