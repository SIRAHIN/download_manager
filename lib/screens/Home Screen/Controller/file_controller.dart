import 'dart:io';
import 'package:downlaod_manager/model/file_mode.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileController extends GetxController {
  

  var downloadProgress = 0.obs;
  //var downloadedFiles = <FileModel>[].obs;
  var downloadedSaveFiles = <FileModel>[].obs;

  var isLoading = false.obs;

Future<bool> downloadFile(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final fileName = url.split('/').last;
      final directory = await getExternalStorageDirectory();
      print(directory);
      final filePath = '${directory!.path}/$fileName';

      print(filePath);

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes); 

      downloadProgress.value = 100;
      saveFileInfo(url, fileName);
      // downloadedFiles.add(FileModel(url: url, fileName: fileName));

      return true;
    } else {
      print('Failed to download file: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error occurred: $e');
    return false;
  }
}


 
  // saving the fileInto in Sp // 
  Future<void> saveFileInfo(String url, String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    final existingFiles = prefs.getStringList('files') ?? [];
    existingFiles.add('$url:$fileName');
    await prefs.setStringList('files', existingFiles);
  }
  
  
  Future<void> loadDownloadedFiles() async {
  isLoading.value = true;  // Start loading

  final prefs = await SharedPreferences.getInstance();
  final existingFiles = prefs.getStringList('files') ?? [];

  // Use Obx or GetX for better state management
  downloadedSaveFiles.value = existingFiles.map((file) {
    final parts = file.split(':');
    return FileModel(url: parts[0], fileName: parts[1]);
  }).toList();

  isLoading.value = false;  // End loading
}
}
