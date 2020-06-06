import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:geolocator/geolocator.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController name;
  TextEditingController address;
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
    address = new TextEditingController();
    description = new TextEditingController();
    _picker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          PlatformText(
            'Name *',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: name,
              ),
            ),
          ),
          PlatformText(
            'Address',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: address,
              ),
            ),
          ),
          PlatformText(
            'Description',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                maxLines: 8,
                controller: description,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 64,
                width: MediaQuery.of(context).size.width / 2 - 22,
                child: RaisedButton(
                  onPressed: () {
                    Future<DateTime> _date = showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2021),
                    );
                    _date.then(
                      (v) {
                        Future<TimeOfDay> _time = showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        _time.then(
                          (_v) => setState(
                            () => date = new DateTime(
                              v.year,
                              v.month,
                              v.day,
                              _v.hour,
                              _v.minute,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: PlatformText(
                    'Set Date and Time',
                  ),
                  color: Color(0xffddeeef),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(
                height: 64,
                width: MediaQuery.of(context).size.width / 4 - 24,
                child: RaisedButton(
                  onPressed: () => getImage(
                    ImageSource.camera,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                  ),
                  color: Color(0xffddefdd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(
                height: 64,
                width: MediaQuery.of(context).size.width / 4 - 24,
                child: RaisedButton(
                  onPressed: () => getImage(
                    ImageSource.gallery,
                  ),
                  child: Icon(
                    Icons.photo_library,
                  ),
                  color: Color(0xffddefdd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          PlatformText(date == null
              ? 'No Date Selected'
              : DateFormat('MMMM dd, yyyy').format(date) +
                  ' at ' +
                  DateFormat('hh:mm').format(date)),
          SizedBox(
            height: 50,
          ),
          _image == null
              ? PlatformText(
                  'No image selected.',
                )
              : Image.file(_image),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 64,
            child: RaisedButton(
              onPressed: () async {
                Position position = await Geolocator()
                    .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                await Firestore.instance.collection('cleanups').add(
                  {
                    'name': name.text,
                    'address':address.text,
                    'description': description.text,
                    'datetime': date,
                    // 'location': position,
                    'imagePath':'graffiti/${_image.path}',
                  },
                );

                StorageReference storageReference = FirebaseStorage.instance
                    .ref()
                    .child('graffiti/${_image.path}');
                StorageUploadTask uploadTask = storageReference.putFile(_image);
                await uploadTask.onComplete;
              },
              child: PlatformText(
                'Push to Firestore',
              ),
              color: Color(0xffeecccc),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
