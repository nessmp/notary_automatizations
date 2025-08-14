import 'package:flutter/material.dart';

import 'csf.dart';
import 'upload_button.dart';

class SideMenuBanner extends StatefulWidget {
  final void Function(Map<String, String>) onDataUpload;
  const SideMenuBanner({super.key, required this.onDataUpload});

  @override
  State<SideMenuBanner> createState() => _SideMenuBanner();
}

class _SideMenuBanner extends State<SideMenuBanner> {
  Future<void> computeFuture = Future.value();

  @override
  Widget build(BuildContext context) => Column(
      children : [
        Expanded(
          flex: 4,
          child: UploadButton(
            onUploadComplete: (uploadedFileName){
              final csf = Csf(uploadedFileName);
              widget.onDataUpload(csf.getData());
            },
          )
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              // TODO(ness): Create docx file.
            },
            child: Text('Button test'),
          ),
        ),
      ],
  );
}
