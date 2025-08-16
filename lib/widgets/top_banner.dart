import 'package:flutter/material.dart';

import 'read_files.dart';
import 'constants.dart';
import 'upload_button.dart';

class TopBanner extends StatefulWidget {
  final void Function(Map<FileTypes, Map<String, String>>) onDataUpload;
  const TopBanner({super.key, required this.onDataUpload});

  @override
  State<TopBanner> createState() => _TopBanner();
}

class _TopBanner extends State<TopBanner> {
  Future<void> computeFuture = Future.value();

  @override
  Widget build(BuildContext context) => Column(
      children : [
        Expanded(
          flex: 4,
          child: UploadButton(
            onUploadComplete: (filesPaths){
              final Map<FileTypes, Map<String, String>> data = {};
              final readFiles = ReadFiles(filesPaths);
              if (readFiles.csfData.isNotEmpty) {
                data[FileTypes.csf] = readFiles.csfData;
              }
              if (readFiles.validityData.isNotEmpty) {
                data[FileTypes.validity] = readFiles.validityData;
              }
              if (readFiles.ineData.isNotEmpty) {
                data[FileTypes.ine] = readFiles.ineData;
              }
              widget.onDataUpload(data);
            },
          )
        ),
        // TODO(ness): Set button visibility depending on form status.
        Visibility(
          visible: false,
          child:Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                // TODO(ness): Create docx file.
              },
              child: Text('Button test'),
            ),
          ),
        ),
      ],
  );
}
