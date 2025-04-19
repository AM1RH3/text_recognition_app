import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextReconitionView extends StatefulWidget {
  const TextReconitionView({super.key});

  @override
  State<TextReconitionView> createState() => _TextReconitionViewState();
}

class _TextReconitionViewState extends State<TextReconitionView> {
  XFile? _photo;
  final textReconition = GoogleMlKit.vision.textRecognizer();

  void _uploadPhoto() async {
    _photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_photo == null) return;
    setState(() {});
    _textrecognition();
  }

  String _recognizedText = '';

  void _textrecognition() async {
    final result = await textReconition.processImage(
      InputImage.fromFilePath(_photo!.path),
    );
    setState(() {
      _recognizedText = result.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Text Recognition',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _photo != null ? Image.file(File(_photo!.path)) : Container(),
            SizedBox(height: 20),
            SizedBox(
              height: 65,
              width: double.infinity,
              child: Container(
                color: Colors.green,
                child: Center(
                  child:
                      _photo == null
                          ? Text(
                            'Upload Image First',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          )
                          : Text(
                            '  Recognized Text : ',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SelectableText(
                _recognizedText,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadPhoto,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
