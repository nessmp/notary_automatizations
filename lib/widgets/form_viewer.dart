import 'package:flutter/material.dart';

import 'constants.dart';
import 'form_non_list_data.dart';

class FormViewer extends StatefulWidget {
  final Map<String, String> data;
  const FormViewer({
    super.key, 
    required this.data,
  });

  @override
  State<FormViewer> createState() => _FormViewer();
}

class _FormViewer extends State<FormViewer> {
  final _formKey = GlobalKey<FormState>();
  final _personalDataControllers = {
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


final _fiscalDataControllers = {
    Constants.kCityLabel : TextEditingController(),
    Constants.kColoniaLabel : TextEditingController(),
    Constants.kCurpLabel : TextEditingController(),
    Constants.kEconomicActivitiesLabel : TextEditingController(),
    Constants.kHouseNumberLabel : TextEditingController(),
    Constants.kRegimesLabel : TextEditingController(),
    Constants.kRfcLabel : TextEditingController(),
    Constants.kStateLabel : TextEditingController(),
    Constants.kStreetLabel : TextEditingController(),
    Constants.kZipCodeLabel : TextEditingController(),
  };

  @override
  void didUpdateWidget(covariant FormViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      for (var controller in _personalDataControllers.entries) {
        controller.value.text = widget.data[controller.key] ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          FormNonListData(
            title: Constants.kPersonalData, 
            controllers: _personalDataControllers),
          FormNonListData(
            title: Constants.kFiscalData,
          controllers: _fiscalDataControllers),
        ],
      ),
    ),
  );
}
