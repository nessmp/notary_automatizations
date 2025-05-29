import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(const HomePage());
}

const double windowWidth = 1024;
const double windowHeight = 800;
void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Crear Generales');
    setWindowMinSize(const Size(windowWidth, windowHeight));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> computeFuture = Future.value();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: computeFuture,
            builder: (context, snapshot) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 8.0),
                onPressed: switch (snapshot.connectionState) {
                  ConnectionState.done =>
                    () => handleClick(context),
                  _ => null,
                },
                child: Text('Button test'),
                );
            },
          ),
        ),
      ),
    );
  }
}

void handleClick(BuildContext context) {
  // TODO(nessmp):
  //    * test code to do character recognition on the INE pic.
  //    * test code to read PDF files (make sure it read both files!)
  print('Button Pressed!');
}