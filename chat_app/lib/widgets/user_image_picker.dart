import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedimagefile;
  void _pickimage() async {
    final pickedimage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedimage == null) {
      return;
    }
    setState(() {
      _pickedimagefile = File(pickedimage.path);
    });
    widget.onPickImage(_pickedimagefile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedimagefile != null ? FileImage(_pickedimagefile!) : null,
        ),
        TextButton.icon(
          onPressed: _pickimage,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
