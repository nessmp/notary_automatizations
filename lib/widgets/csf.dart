import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

class Csf {
  late final DynamicLibrary _lib;
  late final Pointer<Void> _instance;

  late final Pointer<Void> Function(Pointer<Utf8>) _create = _lib
      .lookup<NativeFunction<Pointer<Void> Function(Pointer<Utf8>)>>("create")
      .asFunction();
  late final Pointer<WChar> Function(Pointer<Void>) _getName = _lib
      .lookup<NativeFunction<Pointer<WChar> Function(Pointer<Void>)>>(
        "get_name").asFunction();
  late final void Function(Pointer<Void>) _destroy = _lib
      .lookup<NativeFunction<Void Function(Pointer<Void>)>>("destroy")
      .asFunction();

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

  String getName() {
    final wcharSize = sizeOf<WChar>();
    final namePtr = _getName(_instance);
    return _decodeWideString(namePtr, wcharSize: wcharSize);
  }

  void dispose() {
    _destroy(_instance);
  }

  String _decodeWideString(Pointer<WChar> ptr, {required int wcharSize}) {
  if (ptr.address == 0) {
    return '';
  }

  final codeUnits = <int>[];
  int offset = 0;

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