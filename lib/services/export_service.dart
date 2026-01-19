import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum ExportResult { success, cancelled, failed }

class ExportService {
  Future<ExportResult> exportZip(Uint8List bytes, String fileName) async {
    try {
      String? path;
      if (Platform.isAndroid || Platform.isIOS) {
        path = await FlutterFileDialog.saveFile(
          params: SaveFileDialogParams(
            fileName: fileName,
            mimeTypesFilter: ['application/zip'],
            data: bytes,
          ),
        );
      } else {
        final docsDir = await getApplicationDocumentsDirectory();
        path = docsDir.path;
        final destFile = File(p.join(docsDir.path, fileName));
        await destFile.writeAsBytes(bytes);
      }

      if (path == null) {
        // User dismissed the dialog
        return ExportResult.cancelled;
      }

      return ExportResult.success;
    } catch (e) {
      // PlatformException, MissingPluginException, etc.
      return ExportResult.failed;
    }
  }
}
