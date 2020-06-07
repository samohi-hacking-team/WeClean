import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';

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
  List tags;

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
    Tflite.loadModel(
      model: "tensorflow/model.tflite",
      labels: "tensorflow/dict.txt",
      isAsset: true,
      numThreads: 1,
    ).then((value) => (print("RESPONSEEE $value")));
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
            child: Text(
              this._image != null
                  ? "Take a different picture"
                  : "Take a picture",
            ),
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
          SizedBox(
            height: 64,
            width: MediaQuery.of(context).size.width - 32,
            child: PlatformButton(
              onPressed: () async {
                print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');

                if (_image != null) {
                  var output = await Tflite.runModelOnImage(
                    path: _image.path,
                    imageMean: 0.0,
                    imageStd: 255.0,
                    numResults: 2,
                    threshold: 0.2,
                    asynch: true,
                  );

                  print('~~~~~~~~~~~~~~~~ done ~~~~~~~~~~~~~~~~~~~~~~~~~');
                  print(output);
                  if (output == []) {
                    tags.add("Graffiti on bricks");
                  } else {
                    tags = output;
                  }

                  print("WOWOWOWOOW");
                  Tflite.close();
                  //print(recognitions);
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
