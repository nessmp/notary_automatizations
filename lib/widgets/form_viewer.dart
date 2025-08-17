import 'package:flutter/material.dart';

import 'constants.dart';
import 'data_viewer.dart';

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
  late Map<String, List<TextEditingController>>  _activitiesControllers;
  late Map<String, List<TextEditingController>>  _regimesControllers;

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

  @override
  void didUpdateWidget(covariant FormViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      for (final controller in _personalDataControllers.entries) {
        controller.value.single.text = widget.data[controller.key] ?? '';
      }
      for (final controller in _fiscalDataControllers.entries) {
        controller.value.single.text = widget.data[controller.key] ?? '';
      }
      for (final controllers in _activitiesControllers.entries) {
        for (final controller in controllers.value) {
          controller.dispose();
        }
      }
      final activities = 
        widget.data[Constants.kEconomicActivitiesLabel]?.split(';') ?? [];
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
      final regimes = 
        widget.data[Constants.kRegimesLabel]?.split(';') ?? [];
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
