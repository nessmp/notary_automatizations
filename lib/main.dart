import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'widgets/side_menu_banner.dart';
import 'widgets/form_viewer.dart';

void main() {
  setupWindow();
  runApp(const HomePage());
}

const double windowWidth = 1024;
const double windowHeight = 800;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Notaria 27');
    setWindowMinSize(const Size(windowWidth, windowHeight));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? csfName;

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
                onDataUpload: (name) {
                  setState(() => csfName = name);
                },
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: FormViewer(csfName: csfName ?? ''),
          ),
        ],
      )
    )
  );
}

