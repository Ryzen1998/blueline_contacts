import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  ProfileImagePicker(
      {super.key, required this.contactImagePath, required this.callback});
  String contactImagePath;
  final Function callback;
  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _img = File('');
  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null && image.path != '') {
        setState(() {
          _img = File(image.path);
        });
        widget.contactImagePath = image.path;
        widget.callback(_img);
      }
    } on Exception catch (_, ex) {}
  }

  Widget _getProfileImg() {
    if (widget.contactImagePath != '' && _img?.path == '') {
      if (File(widget.contactImagePath).existsSync()) {
        _img = File(widget.contactImagePath);
        return CircleAvatar(
          radius: 50,
          backgroundImage: Image.file(_img!).image,
        );
      }
    } else if (_img?.path == '') {
      return const CircleAvatar(
        radius: 50,
        child: Icon(Icons.camera_alt),
      );
    }

    return CircleAvatar(
      radius: 50,
      backgroundImage: Image.file(_img!).image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapInside: (event) async {
        await _pickImage();
      },
      child: _getProfileImg(),
    );
  }
}
