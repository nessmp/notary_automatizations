import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class UploadButton extends StatefulWidget {
  final void Function(String) onUploadComplete;
  const UploadButton({super.key, required this.onUploadComplete});


  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  final Logger _logger = Logger('UploadButton');

  Future<void> _pickAndUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
        withData: true, // gets bytes on all platforms (avoid for huge files)
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.single;
      final Uint8List? fileBytes = file.bytes; // populated because withData: true
      if (fileBytes == null) {
        return;
      }
      widget.onUploadComplete(file.path!);
    } catch (e, stackTrace) {
      _logger.severe('Something went wrong', e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _pickAndUpload,
          icon: const Icon(Icons.upload_file),
          label: const Text('Pick & Upload File'),
        ),
      ],
    );
  }
}

