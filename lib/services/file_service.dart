import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

class FileService {
  /// Opens a native "Save As" dialog on all platforms, letting the user
  /// choose where to save the file on their device.
  static Future<String?> saveFile({
    required String name,
    required List<int> bytes,
    required String ext,
    required MimeType mimeType,
  }) async {
    try {
      return await FileSaver.instance.saveAs(
        name: name,
        bytes: Uint8List.fromList(bytes),
        ext: ext,
        mimeType: mimeType,
      );
    } catch (e) {
      debugPrint('Error saving file: $e');
      return null;
    }
  }
}
