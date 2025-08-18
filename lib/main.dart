import 'dart:async';

import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'widgets/top_banner.dart';
import 'widgets/form_viewer.dart';
import 'widgets/constants.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    setWindowTitle(Constants.kWindowTitle);
    setWindowMinSize(const Size(
      Constants.kWindowWidth, Constants.kWindowHeight));

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };

    runApp(const HomePage());
  }, (error, stackTrace) {
    debugPrint('Caught error in zone: $error');
    debugPrintStack(stackTrace: stackTrace);
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<FileTypes, Map<String, String>> _filesData = {};

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold( 
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding( 
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.kTightSpacing),
              child: TopBanner(
                onDataUpload: (data) {
                  final updatedData = {
                    for (final entry in _filesData.entries)
                      entry.key: Map<String, String>.from(entry.value)
                  };

                  data.forEach((fileType, fileData) {
                    updatedData[fileType] = updatedData[fileType] ?? {};

                    fileData.forEach((field, value) {
                      final hasKey = updatedData[fileType]!.containsKey(field);
                      final shouldReplace = !hasKey || (value.isNotEmpty);

                      if (shouldReplace) {
                        updatedData[fileType]![field] = value;
                      }
                    });
                  });
                  setState(() => _filesData = updatedData);

                },
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(Constants.kSectionsSpacing),
              child: FormViewer(data: _filesData),
            ),
          ),
        ],
      )
    )
  );
}
