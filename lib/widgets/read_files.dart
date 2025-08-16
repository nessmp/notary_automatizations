import 'constants.dart';
import 'read_csf.dart';
import 'read_validity.dart';
import 'read_ine.dart';

class ReadFiles {
  ReadFiles(Map<Enum, String> filePaths) {
    if (filePaths.containsKey(FileTypes.csf)) {
      _csfData = ReadCsf(filePaths[FileTypes.csf]!).data;
    }
    if (filePaths.containsKey(FileTypes.validity)) {
      _validityData = ReadValidity(filePaths[FileTypes.validity]!).data;
    }
    if (filePaths.containsKey(FileTypes.ine)) {
      _ineData = ReadIne(filePaths[FileTypes.ine]!).data;
    }
  }

  Map<String, String> _csfData = {};
  Map<String, String> get csfData => _csfData;

  Map<String, String> _validityData = {};
  Map<String, String> get validityData => _validityData;

  Map<String, String> _ineData = {};
  Map<String, String> get ineData => _ineData;
}
