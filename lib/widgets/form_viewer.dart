import 'package:flutter/material.dart';

class FormViewer extends StatefulWidget {
  final String csfName;
  const FormViewer({
    super.key, 
    required this.csfName,
  });

  @override
  State<FormViewer> createState() => _FormViewer();
}

class _FormViewer extends State<FormViewer> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void didUpdateWidget(covariant FormViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.csfName != oldWidget.csfName) {
      _controller.text = widget.csfName;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, right: 8),
    child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: const OutlineInputBorder(),
                    ),
                    readOnly: false,
                  ),
                  SizedBox(height: 8), 
                  TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: const OutlineInputBorder(),
                    ),
                    readOnly: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}