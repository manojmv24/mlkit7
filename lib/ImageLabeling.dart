import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabeling extends StatefulWidget {
  const ImageLabeling({super.key});

  @override
  _ImageLabelingState createState() => _ImageLabelingState();
}

class _ImageLabelingState extends State<ImageLabeling> {
  File? _image;
  List<ImageLabel> _labels = [];
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();
  final ImageLabeler _imageLabeler = GoogleMlKit.vision.imageLabeler();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _loading = true;
      });

      _labelImage(File(pickedFile.path));
    }
  }

  Future<void> _labelImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final labels = await _imageLabeler.processImage(inputImage);

    setState(() {
      _labels = labels;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Labeling with ML Kit'),
      ),
      body: Column(
        children: [
          _image == null ? const Center(child: Text('No image selected.')) : Image.file(_image!),
          const SizedBox(height: 16.0),
          _loading
              ? const CircularProgressIndicator()
              : _labels.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _labels.length,
                        itemBuilder: (context, index) {
                          final label = _labels[index];
                          return ListTile(
                            title: Text(label.label),
                            subtitle: Text('Confidence: ${label.confidence.toStringAsFixed(2)}'),
                          );
                        },
                      ),
                    )
                  : Container(),
          FloatingActionButton(
            onPressed: _pickImage,
            tooltip: 'Pick Image',
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
