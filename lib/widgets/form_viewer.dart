import 'package:flutter/material.dart';

import 'constants.dart';
import 'data_viewer.dart';

class FormViewer extends StatefulWidget {
  final Map<FileTypes, Map<String, String>> data;
  const FormViewer({
    super.key, 
    required this.data,
  });

  @override
  State<FormViewer> createState() => _FormViewer();
}

class _FormViewer extends State<FormViewer> {
  _FormViewer() {
    _activitiesControllers = {
      Constants.kEconomicActivitiesLabel: [TextEditingController()],
    };
    _regimesControllers = {
      Constants.kRegimesLabel: [TextEditingController()],
    };
  }

  final _formKey = GlobalKey<FormState>();
  final _personalDataControllers = {
    Constants.kBirthDateLabel : [TextEditingController()],
    Constants.kCicLabel : [TextEditingController()],
    Constants.kCityLabel : [TextEditingController()],
    Constants.kColoniaLabel : [TextEditingController()],
    Constants.kCurpLabel : [TextEditingController()],
    Constants.kHouseNumberLabel : [TextEditingController()],
    Constants.kNameLabel : [TextEditingController()],
    Constants.kOcrLabel : [TextEditingController()],
    Constants.kRfcLabel : [TextEditingController()],
    Constants.kStateLabel : [TextEditingController()],
    Constants.kStreetLabel : [TextEditingController()],
    Constants.kZipCodeLabel : [TextEditingController()],
  };

  final _fiscalDataControllers = {
    Constants.kCityLabel : [TextEditingController()],
    Constants.kColoniaLabel : [TextEditingController()],
    Constants.kHouseNumberLabel : [TextEditingController()],
    Constants.kStateLabel : [TextEditingController()],
    Constants.kStreetLabel : [TextEditingController()],
    Constants.kZipCodeLabel : [TextEditingController()],
  };

  late Map<String, List<TextEditingController>>  _activitiesControllers;
  late Map<String, List<TextEditingController>>  _regimesControllers;

  final controllerFileType = {
    Constants.kBirthDateLabel : FileTypes.csf,
    Constants.kCityLabel : FileTypes.csf,
    Constants.kColoniaLabel : FileTypes.csf,
    Constants.kCurpLabel : FileTypes.csf,
    Constants.kHouseNumberLabel : FileTypes.csf,
    Constants.kNameLabel : FileTypes.csf,
    Constants.kRfcLabel : FileTypes.csf,
    Constants.kStateLabel : FileTypes.csf,
    Constants.kStreetLabel : FileTypes.csf,
    Constants.kZipCodeLabel : FileTypes.csf,

    Constants.kEconomicActivitiesLabel : FileTypes.csf,
    Constants.kRegimesLabel : FileTypes.csf,

    Constants.kCicLabel : FileTypes.validity,
    Constants.kOcrLabel : FileTypes.validity,
  };

  @override
  void didUpdateWidget(covariant FormViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      // TODO(ness): Consider adding a feature to detect duplicate-missmatching
      // information, showing a warning and allowing the user to chose one of 
      // them? Prioritizing user input and/or more rediable files.

      for (final controller in _personalDataControllers.entries) {
        final fileTypeData = widget.data[controllerFileType[controller.key]];
        controller.value.single.text = fileTypeData?[controller.key] ?? '';
      }
      for (final controller in _fiscalDataControllers.entries) {
        final fileTypeData = widget.data[controllerFileType[controller.key]];
        controller.value.single.text = fileTypeData?[controller.key] ?? '';
      }
      for (final controllers in _activitiesControllers.entries) {
        for (final controller in controllers.value) {
          controller.dispose();
        }
      }
      final activitiesFileData = 
        widget.data[controllerFileType[Constants.kEconomicActivitiesLabel]];
      final activities = 
        activitiesFileData?[Constants.kEconomicActivitiesLabel]?.split(';') ?? [];
      final activitiesControllers = [
        ...activities.map((activity) =>
        TextEditingController(text: activity)),
        TextEditingController(),
      ];
      _activitiesControllers[Constants.kEconomicActivitiesLabel] = 
        activitiesControllers;

      for (final controllers in _regimesControllers.entries) {
        for (final controller in controllers.value) {
          controller.dispose();
        }
      }
      final regimesFileData = 
        widget.data[controllerFileType[Constants.kRegimesLabel]];
      final regimes = 
        regimesFileData?[Constants.kRegimesLabel]?.split(';') ?? [];
      final regimesControllers = [
        ...regimes.map((regime) =>
        TextEditingController(text: regime)),
        TextEditingController(),
      ];
      _regimesControllers[Constants.kRegimesLabel] = regimesControllers;
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          DataViewer(
            title: Constants.kPersonalData, 
            controllers: _personalDataControllers),
          DataViewer(
            title: Constants.kFiscalData,
            controllers: _fiscalDataControllers),
          DataViewer(
            title: Constants.kEconomicActivities,
            controllers: _activitiesControllers),
          DataViewer(
            title: Constants.kRegimes,
            controllers: _regimesControllers),
        ],
      ),
    ),
  );
}
