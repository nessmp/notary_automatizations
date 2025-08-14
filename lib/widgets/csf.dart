import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'constants.dart';

class Csf {
  late final DynamicLibrary _lib;
  late final Pointer<Void> _instance;

  late final Pointer<Void> Function(Pointer<Utf8>) _create = _lib
      .lookup<NativeFunction<Pointer<Void> Function(Pointer<Utf8>)>>("create")
      .asFunction();
  late final void Function(Pointer<Void>) _destroy = _lib
      .lookup<NativeFunction<Void Function(Pointer<Void>)>>("destroy")
      .asFunction();
      
  late final Pointer<WChar> Function(Pointer<Void>) _getBirthDate = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_birth_date").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getCity = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_city").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getColonia = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_colonia").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getCurp = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_curp").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getEconomicActivities = 
    _lib.lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_economic_activities").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getHouseNumber = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_house_number").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getName = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_name").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getRegimes = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_regimes").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getRfc = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_rfc").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getState = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_state").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getStreet = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_street").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getZipCode = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_zip_code").asFunction();

  Csf(String filePath) {
    _lib = _loadLibrary();
    _instance = _create(filePath.toNativeUtf8());
  }

  DynamicLibrary _loadLibrary() => DynamicLibrary.open(
    // TODO(ness): Change this path to the correct one for MacOS and 
    // Windows.
    Platform.isMacOS ? 'libread_csf_wrapper.dylib' :
    Platform.isWindows ? 'libread_csf_wrapper.dll' :
    'build/linux/x64/debug/libread_csf_wrapper.so');

  Map<String, String> getData() => {
    Constants.kBirthDateLabel : getBirthDate(),
    Constants.kCityLabel : getCity(),
    Constants.kColoniaLabel : getColonia(),
    Constants.kCurpLabel : getCurp(),
    Constants.kEconomicActivitiesLabel : getEconomicActivities(),
    Constants.kHouseNumberLabel : getHouseNumber(),
    Constants.kNameLabel : getName(),
    Constants.kRegimesLabel : getRegimes(),
    Constants.kRfcLabel : getRfc(),
    Constants.kStateLabel : getState(),
    Constants.kStreetLabel : getStreet(),
    Constants.kZipCodeLabel : getZipCode(),
  };

   String getBirthDate() => _decodeWideString(_getBirthDate(_instance));
   String getCity() => _decodeWideString(_getCity(_instance));
   String getColonia() => _decodeWideString(_getColonia(_instance));
   String getCurp() => _decodeWideString(_getCurp(_instance)); 
   String getEconomicActivities() => _decodeWideString(_getEconomicActivities(_instance));
   String getHouseNumber() => _decodeWideString(_getHouseNumber(_instance));
   String getName() => _decodeWideString(_getName(_instance));
   String getRegimes() => _decodeWideString(_getRegimes(_instance));
   String getRfc() => _decodeWideString(_getRfc(_instance));
   String getState() => _decodeWideString(_getState(_instance));
   String getStreet() => _decodeWideString(_getStreet(_instance));
   String getZipCode() => _decodeWideString(_getZipCode(_instance));

  void dispose() {
    _destroy(_instance);
  }

  String _decodeWideString(Pointer<WChar> ptr) {
    if (ptr.address == 0) {
      return '';
    }

    final codeUnits = <int>[];
    int offset = 0;
    int wcharSize = sizeOf<WChar>();

    while (true) {
      int unit;
      if (wcharSize == 2) {
        unit = ptr.cast<Uint16>()[offset];
      } else if (wcharSize == 4) {
        unit = ptr.cast<Uint32>()[offset];
      } else {
        throw UnsupportedError('Unsupported wchar_t size: $wcharSize');
      }

      if (unit == 0) break; // null terminator

      if (wcharSize == 4) {
        if (unit >= 0xD800 && unit <= 0xDFFF) {
          offset++;
          continue; // Skip surrogate halves
        }
        if (unit > 0x10FFFF) {
          offset++;
          continue; // Skip invalid code points
        }
      }

      codeUnits.add(unit);
      offset++;
    }

    return String.fromCharCodes(codeUnits);
  }
}
