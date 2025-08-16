import 'package:flutter/material.dart';

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
      _createTextFormField(
        Constants.kNameLabel, 
        widget.controllers[Constants.kNameLabel]!, 
        Constants.kFieldsSpacing) : 
      const SizedBox.shrink();

  Widget get _birthDateWidget => 
    widget.controllers.containsKey(Constants.kBirthDateLabel) ? 
      _createTextFormField(
        Constants.kBirthDateLabel, 
        widget.controllers[Constants.kBirthDateLabel]!,
        Constants.kFieldsSpacing) : 
      const SizedBox.shrink();

  Widget get _columnsWidget {
    const List<String> leftColumnsKeys = [
      'CIC', 
      Constants.kStateLabel,
      Constants.kColoniaLabel,
      Constants.kStreetLabel,
    ];
    
    const List<String> rightColumnKeys = [
      'OCR', 
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
                _createTextFormField(entry.key, 
                  columnControllers[entry.key]!, 
                  Constants.kFieldsSpacing),
              ).toList(),
          ),
        ),
        SizedBox(width: Constants.kFieldsSpacing),
        Expanded(
          flex: 1,
          child: Column(
            children: columnControllers.entries.where((entry) => 
              rightColumnKeys.contains(entry.key)).map((entry) =>
                _createTextFormField(
                  entry.key, 
                  columnControllers[entry.key]!, 
                  Constants.kFieldsSpacing),
              ).toList(),
          ),
        ),
      ],
    );
  }

  Widget get _activitiesWidget => 
    widget.controllers.containsKey(Constants.kEconomicActivitiesLabel) ? 
      _createTextFormField(
        Constants.kEconomicActivitiesLabel, 
        widget.controllers[Constants.kEconomicActivitiesLabel]!, 
        Constants.kFieldsSpacing) : 
      const SizedBox.shrink();

  Widget get _regimesWidget => 
    widget.controllers.containsKey(Constants.kRegimesLabel) ? 
      _createTextFormField(
        Constants.kRegimesLabel, 
        widget.controllers[Constants.kRegimesLabel]!, 
        Constants.kFieldsSpacing) : 
      const SizedBox.shrink();


  Widget _createTextFormField(
   String label, 
   TextEditingController controller, 
   double bottomHeight) => Column(
    children: [ 
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: false,
      ),
      SizedBox(height: bottomHeight),
    ],
  );
}
