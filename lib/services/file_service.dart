import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import '../config/api_constants.dart';

class FileService {
  // Pick XPS file
  Future<File?> pickXpsFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xps'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        // Validate file size
        int fileSize = await file.length();
        if (fileSize > ApiConstants.maxFileSize) {
          throw Exception(
              'File size must be less than ${ApiConstants.maxFileSize ~/ (1024 * 1024)} MB');
        }

        return file;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get file name from path
  String getFileName(String filePath) {
    return path.basename(filePath);
  }

  // Get file size in readable format
  String getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Save file to downloads
  Future<String?> saveToDownloads(String url, String fileName) async {
    try {
      Directory directory;

      if (Platform.isAndroid) {
        Directory androidDir = Directory('/storage/emulated/0/Download');
        if (await androidDir.exists()) {
          directory = androidDir;
        } else {
          final externalDir = await getExternalStorageDirectory();
          if (externalDir == null) {
            throw Exception('Could not access external storage');
          }
          directory = externalDir;
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir == null) {
          throw Exception('Could not access downloads directory');
        }
        directory = downloadsDir;
      }

      final filePath = path.join(directory.path, fileName);
      return filePath;
    } catch (e) {
      print('Error getting save path: $e');
      return null;
    }
  }

  // Open file
  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception(result.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Check if file exists
  Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  // Delete file
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  // Get file extension
  String getFileExtension(String fileName) {
    return path.extension(fileName).toLowerCase();
  }

  // Validate XPS file
  bool isValidXpsFile(String fileName) {
    return getFileExtension(fileName) == '.xps';
  }
}
