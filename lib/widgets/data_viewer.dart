import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'constants.dart';

class DataViewer extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  final String title;

  const DataViewer({
    super.key, 
    required this.controllers, 
    this.title = ''});

  @override
  State<DataViewer> createState() => _DataViewerState();
}

class _DataViewerState extends State<DataViewer> {
  @override
  Widget build(BuildContext context) => Column(
    children: [
        _titleWidget, 
        _nameWidget,
        _birthDateWidget,
        _columnsWidget,
        _activitiesWidget,
        _regimesWidget,
    ],
  );

  Widget get _titleWidget => widget.title.isEmpty ? 
    const SizedBox.shrink() : 
    Text(
      widget.title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      )
    );

  Widget get _nameWidget => 
    widget.controllers.containsKey(Constants.kNameLabel) ? 
      _createFormTextField(Constants.kNameLabel, widget.controllers[Constants.kNameLabel]!) : 
      const SizedBox.shrink();

  Widget get _birthDateWidget => 
    widget.controllers.containsKey(Constants.kBirthDateLabel) ? 
      _createFormTextField(
        Constants.kBirthDateLabel, 
        widget.controllers[Constants.kBirthDateLabel]!) : 
      const SizedBox.shrink();

  Widget get _columnsWidget {
    const List<String> leftColumnsKeys = [
      // 'CIC', 
      Constants.kStateLabel,
      Constants.kColoniaLabel,
      Constants.kStreetLabel,
    ];
    
    const List<String> rightColumnKeys = [
      // 'OCR', 
      Constants.kCityLabel,
      Constants.kZipCodeLabel,
      Constants.kHouseNumberLabel,
    ];

    final columnControllers = Map.fromEntries(
      widget.controllers.entries.where((entry) => 
        leftColumnsKeys.contains(entry.key)|| 
        rightColumnKeys.contains(entry.key)));

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: columnControllers.entries.where((entry) => 
              leftColumnsKeys.contains(entry.key)).map((entry) =>
                _createFormTextField(entry.key, 
                  columnControllers[entry.key]!),
              ).toList(),
          ),
        ),
        SizedBox(width: Constants.kFieldsSpacing),
        Expanded(
          flex: 1,
          child: Column(
            children: columnControllers.entries.where((entry) => 
              rightColumnKeys.contains(entry.key)).map((entry) =>
                _createFormTextField(
                  entry.key, 
                  columnControllers[entry.key]!),
              ).toList(),
          ),
        ),
      ],
    );
  }

  Widget get _activitiesWidget => 
    widget.controllers.containsKey(Constants.kEconomicActivitiesLabel) ? 
      _createFormTextField(
        Constants.kEconomicActivitiesLabel, 
        widget.controllers[Constants.kEconomicActivitiesLabel]!) : 
      const SizedBox.shrink();

  Widget get _regimesWidget => 
    widget.controllers.containsKey(Constants.kRegimesLabel) ? 
      _createFormTextField(
        Constants.kRegimesLabel, 
        widget.controllers[Constants.kRegimesLabel]!) : 
      const SizedBox.shrink();


  Widget _createFormTextField(
   String label, 
   TextEditingController controller) => Column(
    children: [ 
      FormBuilderTextField(
        name: label,
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.email(),
        ]),
      ),
      SizedBox(height: Constants.kFieldsSpacing),
    ],
  );
}
