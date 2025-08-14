import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'widgets/side_menu_banner.dart';
import 'widgets/form_viewer.dart';
import 'widgets/constants.dart';

void main() {
  setupWindow();
  runApp(const HomePage());
}

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle(Constants.kWindowTitle);
    setWindowMinSize(
      const Size(Constants.kWindowWidth, Constants.kWindowHeight));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String>? _csfData;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold( 
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SideMenuBanner(
                onDataUpload: (data) {
                  setState(() { 
                    _csfData = data;
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: FormViewer(csfData: _csfData ?? {}),
          ),
        ],
      )
    )
  );
}
