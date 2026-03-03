import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<String?> saveFile({
    required String name,
    required List<int> bytes,
    required String ext,
    required MimeType mimeType,
  }) async {
    if (kIsWeb) {
      return await FileSaver.instance.saveFile(
        name: name,
        bytes: Uint8List.fromList(bytes),
        ext: ext,
        mimeType: mimeType,
      );
    } else {
      // For Android, we try to save in Documents
      try {
        String? path;
        if (Platform.isAndroid) {
           // On Android, we can use file_saver too for better compatibility with modern Android
           return await FileSaver.instance.saveFile(
            name: name,
            bytes: Uint8List.fromList(bytes),
            ext: ext,
            mimeType: mimeType,
          );
        } else {
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/$name.$ext');
          await file.writeAsBytes(bytes);
          path = file.path;
        }
        return path;
      } catch (e) {
        debugPrint('Error saving file: $e');
        return null;
      }
    }
  }
}
