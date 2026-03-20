import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileService {
  /// Opens a native "Save As" dialog on all platforms, letting the user
  /// choose where to save the file on their device.
  static Future<String?> saveFile({
    required String name,
    required List<int> bytes,
    required String ext,
  }) async {
    try {
      final uint8Bytes = Uint8List.fromList(bytes);

      // Use file_picker which opens the native system dialog.
      // This works on Linux, Windows, macOS, Android, and iOS.
      // IMPORTANT: On Android and iOS, 'bytes' are REQUIRED for saveFile to work.
      // On mobile, the plugin handles the actual write operation to the selected URI.
      final String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select where to save your $ext file:',
        fileName: '$name.$ext',
        type: ext == 'pdf' ? FileType.custom : FileType.any,
        allowedExtensions: ext == 'pdf' ? ['pdf'] : null,
        bytes: uint8Bytes,
      );

      if (outputPath == null) {
        // User canceled the picker
        return null;
      }

      // On Desktop platforms, if it returns a path but didn't write the file,
      // we perform a manual write as an extra safety measure.
      // CRITICAL: We skip this on Android/iOS because 'outputPath' often contains
      // a content provider URI (e.g., /document/123) that dart:io cannot resolve.
      if (!Platform.isAndroid && !Platform.isIOS) {
        final file = File(outputPath);
        if (!await file.exists() || (await file.length()) == 0) {
          await file.writeAsBytes(uint8Bytes);
        }
      }

      return outputPath;
    } catch (e) {
      debugPrint('Error saving file with native dialog: $e');
      return null;
    }
  }
}
