import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'constants.dart';

class UploadButton extends StatefulWidget {
  final void Function(Map<Enum, String>) onUploadComplete;
  const UploadButton({super.key, required this.onUploadComplete});


  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  final Logger _logger = Logger('UploadButton');

  Future<void> _pickAndUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any);
      if (result == null || result.files.isEmpty) {
        return;
      }

      final Map<Enum, String> filesPaths = {};

      // TODO(ness): Change this to a more robust file detection.
      final csfFile = result.files.where((file) => 
        file.name.endsWith('csf.pdf')).firstOrNull;
      if (csfFile != null) {
        filesPaths[FileTypes.csf] = csfFile.path!;
      }

      final ineFile = result.files.where((file) => 
        file.name.endsWith('ine.pdf')).firstOrNull;
      if (ineFile != null) {
        filesPaths[FileTypes.ine] = ineFile.path!;
      }

      final validityFile = result.files.where((file) => 
        file.name.endsWith('vigencia.jpg')).firstOrNull;
      if (validityFile != null) {
        filesPaths[FileTypes.validity] = validityFile.path!;
      }

      widget.onUploadComplete(filesPaths);
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

