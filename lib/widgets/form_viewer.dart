import 'package:flutter/material.dart';

import 'constants.dart';

class FormViewer extends StatefulWidget {
  final Map<String, String> csfData;
  const FormViewer({
    super.key, 
    required this.csfData,
  });

  @override
  State<FormViewer> createState() => _FormViewer();
}

class _FormViewer extends State<FormViewer> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = {
    Constants.kBirthDateLabel : TextEditingController(),
    Constants.kCityLabel : TextEditingController(),
    Constants.kColoniaLabel : TextEditingController(),
    Constants.kCurpLabel : TextEditingController(),
    Constants.kEconomicActivitiesLabel : TextEditingController(),
    Constants.kHouseNumberLabel : TextEditingController(),
    Constants.kNameLabel : TextEditingController(),
    Constants.kRegimesLabel : TextEditingController(),
    Constants.kRfcLabel : TextEditingController(),
    Constants.kStateLabel : TextEditingController(),
    Constants.kStreetLabel : TextEditingController(),
    Constants.kZipCodeLabel : TextEditingController(),
  };

  @override
  void didUpdateWidget(covariant FormViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.csfData != oldWidget.csfData) {
      for (var controller in _controllers.entries) {
        controller.value.text = widget.csfData[controller.key] ?? '';
      }
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
                children:
                  _controllers.entries.map((entry) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextFormField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: entry.key,
                          border: const OutlineInputBorder(),
                        ),
                        readOnly: false,
                      )
                    )
                  ).toList(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
