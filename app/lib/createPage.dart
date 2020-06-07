import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:geolocator/geolocator.dart';
import 'package:tflite/tflite.dart';

import 'package:flutter/services.dart';


class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController name;
  TextEditingController description;

  File _image;
  ImagePicker _picker;
  final picker = ImagePicker();

  DateTime date;

  Future getImage(source) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        imageQuality: 100,
      );
      setState(() {
        _image = File(pickedFile.path);
      });
    } catch (e) {
      setState(() {
        print(e);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    name = new TextEditingController();
    description = new TextEditingController();
    _picker = new ImagePicker();

    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    bool _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false; 
      });
    });
  }

  Future loadModel() async {
    Tflite.close();
    try {
      String res;
          res = await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt",
          );
      print(res);
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Future recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Container(
            height: 90,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlatformText(
              'Describe what needs cleaning',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          PlatformTextField(
            maxLines: 4,
            maxLength: 100,
            maxLengthEnforced: true,
            controller: description,
          ),
          SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 8,
          ),
          PlatformButton(
            child: Text(this._image != null
                ? "Take a different picture"
                : "Take a picture"),
            onPressed: () => getImage(
              ImageSource.gallery,
            ),
          ),
          _image == null
              ? PlatformText(
                  'Please take an image so we can analyze what your cleaners need',
                  textAlign: TextAlign.center,
                )
              : Image.file(_image),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: Container(),
          ),
          SizedBox(
            height: 64,
            width: MediaQuery.of(context).size.width - 32,
            child: PlatformButton(
              onPressed: () async {
                print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~2');
                if (_image != null) {
                  print(
                      'inside rn omg I never thought I would ever make it in!!!!');
                  var recognitions = await Tflite.runModelOnImage(
                    path: _image.path,
                    numResults: 6,
                    threshold: 0.05,
                    imageMean: 127.5,
                    imageStd: 127.5,
                  );
                  print('I did not finish once I was inside. I am a faliur');
                  await Tflite.close();

                  print('~~~~~~~~~~~~~~~~ done ~~~~~~~~~~~~~~~~~~~~~~~~~');

                  print(recognitions);
                }
                print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~```');

                // Position position = await Geolocator()
                //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                // StorageReference storageReference = FirebaseStorage.instance
                //     .ref()
                //     .child('graffiti/${_image.path}');
                // StorageUploadTask uploadTask = storageReference.putFile(_image);
                // await uploadTask.onComplete;

                print('OMG I FINALLY FINISHED IT FELT SO AMAZINGLY GOOD');
              },
              child: PlatformText(
                'Submit',
              ),
              color: isMaterial(context)
                  ? Colors.blue
                  : (CupertinoTheme.brightnessOf(context) == Brightness.light
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.systemGrey4),
            ),
          ),
          Container(
            height: 100,
          ),
        ],
      ),
    );
  }
}
