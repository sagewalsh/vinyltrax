import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
    _controller = CameraController(widget.camera!, ResolutionPreset.max);
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
                setState(() {});
              },
              child: Text("Take Picture"),
            ),
          ),
          //Underneath I have it so the pictureFile!.path will give the correct file path
          if (pictureFile != null)
            Image.file(
              File(pictureFile!.path),
              height: 300,
            ),
        ],
      ),

    );
  }
}
