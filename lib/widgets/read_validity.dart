import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'constants.dart';

class ReadValidity {
  late final DynamicLibrary _lib;
  late final Pointer<Void> _instance;

  ReadValidity(String filePath) {
    _lib = _loadLibrary();
    _instance = _create(filePath.toNativeUtf8());
  }

  Map<String, String> get data => {
    Constants.kCicLabel : getCic(),
    Constants.kOcrLabel : getOcr(),
  };

  String getCic() => _decodeWideString(_getCic(_instance));
  String getOcr() => _decodeWideString(_getOcr(_instance));

  late final Pointer<Void> Function(Pointer<Utf8>) _create = _lib
    .lookup<NativeFunction<Pointer<Void> Function(Pointer<Utf8>)>>("create")
    .asFunction();
  late final void Function(Pointer<Void>) _destroy = _lib
    .lookup<NativeFunction<Void Function(Pointer<Void>)>>("destroy")
    .asFunction();

  late final Pointer<WChar> Function(Pointer<Void>) _getCic = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_cic").asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getOcr = _lib
    .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
      "get_ocr").asFunction();

  DynamicLibrary _loadLibrary() => DynamicLibrary.open(
    // TODO(ness): Change this path to the correct one for MacOS and 
    // Windows.
    Platform.isMacOS ? 'libread_validity_wrapper.dylib' :
    Platform.isWindows ? 'libread_validity_wrapper.dll' :
    'build/linux/x64/debug/libread_validity_wrapper.so');
      
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