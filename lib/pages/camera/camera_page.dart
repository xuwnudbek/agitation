import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;

  List<CameraDescription> cameras = [];
  bool isLoading = true;
  int cameraPosition = 1;
  @override
  void initState() {
    super.initState();
    onInit();
  }

  onInit() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg);

    controller.initialize().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  onChangeCamera() {
    if (cameraPosition == 0) {
      cameraPosition = 1;
    } else {
      cameraPosition = 0;
    }

    controller = CameraController(
        cameras[cameraPosition], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg);

    controller.initialize().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                color: Colors.red,
                child: 
                // Transform.scale(
                //     scale: controller.value.aspectRatio /Get.width / Get.height,

                //     child: Center(
                //       child: 
                      AspectRatio(
                        aspectRatio: 1/controller.value.aspectRatio,
                        child: 
                        CameraPreview(controller),
                      ),
                  //   ),
                  // ),
              )
          // Column(
          //     children: [
          //       Row(),
          //       SizedBox(
          //         // width:100,
          //         height: Get.height*0.85,
          //         child: CameraPreview(
          //           controller,
          //         ),
          //       ),
          //     ],
          //   ),
          ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                // onChangeCamera();
              },
              splashColor: Colors.white,
            ),
            FloatingActionButton(
              child: const Icon(Icons.camera),
              onPressed: () {
                if (!isLoading) {
                  controller.takePicture().then((value) {
                    Get.back(result: value.path);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ImageDisplayWidget(
                    //       imagePath: value.path,
                    //     ),
                    //   ),
                    // );
                  });
                }
              },
            ),
            IconButton(
                onPressed: () {
                  onChangeCamera();
                },
                icon: Icon(Icons.refresh))
          ],
        ),
      ),
    );
  }
}

class ImageDisplayWidget extends StatelessWidget {
  final String imagePath;

  const ImageDisplayWidget({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            SizedBox(
                // height: Get.height * 0.8,
                width: Get.width,
                child: Image.file(File(imagePath))),
            // Positioned(
            //   bottom: 10,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       FloatingActionButton(
            //         onPressed: () {},
            //         backgroundColor: Colors.red,
            //         child: Icon(Icons.cancel_outlined),
            //       ),
            //       FloatingActionButton(
            //         onPressed: () {},
            //         backgroundColor: Colors.green,
            //         child: Icon(Icons.check),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
