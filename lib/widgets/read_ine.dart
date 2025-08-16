// TODO(ness): Implement the actual FFI calls to the c++ library.
class ReadIne {
  ReadIne(String filePath);

  Map<String, String> get data => {};

  // DynamicLibrary _loadLibrary() => DynamicLibrary.open(
  //   // TODO(ness): Change this path to the correct one for MacOS and 
  //   // Windows.
  //   Platform.isMacOS ? 'libread_validity_wrapper.dylib' :
  //   Platform.isWindows ? 'libread_validity_wrapper.dll' :
  //   'build/linux/x64/debug/libread_validity_wrapper.so');
      
  void dispose() {}
}