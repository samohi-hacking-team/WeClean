import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';

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

  Future getImage(source) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        // imageQuality: quality,
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
                  onPressed: () {},
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
          )
        ],
      ),
    );
  }
}
