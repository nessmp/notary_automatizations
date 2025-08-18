import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'constants.dart';

class DataViewer extends StatefulWidget {
  final Map<String, List<TextEditingController>> controllers;
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
        _idWidget,
        _addressWidget,
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
      _createFormTextField(
        [Constants.kNameLabel], 
        widget.controllers[Constants.kNameLabel]!) : 
      const SizedBox.shrink();

  Widget get _birthDateWidget => 
    widget.controllers.containsKey(Constants.kBirthDateLabel) ? 
      _createFormTextField(
        [Constants.kBirthDateLabel], 
        widget.controllers[Constants.kBirthDateLabel]!) : 
      const SizedBox.shrink();

  Widget _columnWidget(
    List<String> leftColumnsKeys, 
    List<String> rightColumnKeys) {
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
                _createFormTextField([entry.key], 
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
                  [entry.key], 
                  columnControllers[entry.key]!),
              ).toList(),
          ),
        ),
        SizedBox(width: Constants.kFieldsSpacing),
      ],
    );
  }

  Widget get _idWidget {
    const List<String> leftColumnsKeys = [
      Constants.kCurpLabel,
      Constants.kCicLabel, 
    ];
    const List<String> rightColumnKeys = [
      Constants.kRfcLabel,
      Constants.kOcrLabel,
    ];
  
    return _columnWidget(leftColumnsKeys, rightColumnKeys);
  }

  Widget get _addressWidget {
    const List<String> leftColumnsKeys = [
      Constants.kStateLabel,
      Constants.kColoniaLabel,
      Constants.kStreetLabel,
    ];
    const List<String> rightColumnKeys = [
      Constants.kCityLabel,
      Constants.kZipCodeLabel,
      Constants.kHouseNumberLabel,
    ];
 
    return _columnWidget(leftColumnsKeys, rightColumnKeys);
 }

  Widget get _activitiesWidget {
    if (widget.controllers.containsKey(Constants.kEconomicActivitiesLabel)) {
      final labels = List.generate(
        widget.controllers[Constants.kEconomicActivitiesLabel]!.length,
        (index) => '${index + 1} - ${Constants.kEconomicActivity}');
      return _createFormTextField(labels, 
        widget.controllers[Constants.kEconomicActivitiesLabel]!);
    }
    return const SizedBox.shrink();
  }

  Widget get _regimesWidget {
    if (widget.controllers.containsKey(Constants.kRegimesLabel)) {
      final labels = List.generate(
        widget.controllers[Constants.kRegimesLabel]!.length,
        (index) => '${index + 1} - ${Constants.kRegime}');
      return _createFormTextField(labels, 
        widget.controllers[Constants.kRegimesLabel]!);
    }
    return const SizedBox.shrink();
  }

  Widget _createFormTextField(
   List<String> labels, 
   List<TextEditingController> controllers) => Column(
    children: List.generate(
      labels.length, 
      (index) => Column(
        children: [
          FormBuilderTextField(
            name: labels[index],
            controller: controllers[index],
            decoration: InputDecoration(labelText: labels[index]),
          ),
          SizedBox(height: Constants.kFieldsSpacing),
        ],
      )
    )
  );
}
