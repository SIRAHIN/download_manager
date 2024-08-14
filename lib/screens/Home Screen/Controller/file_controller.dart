import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downlaod_manager/model/file_mode.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FileController extends GetxController {
  var downloadProgress = (0.0).obs;
  //var downloadedFiles = <FileModel>[].obs;
  var isDownloadStart = false.obs;
  var downloadedSaveFiles = <FileModel>[].obs;

  var isLoading = false.obs;

  // Dowanload file with dio and getiing the DownloadProgress Value Try Case 2.0 //
  Future<bool> downloadFile(String url) async {
    isDownloadStart.value = true;
    try {
      final dio = Dio();
      final fileName = url.split('/').last;
      //  print(fileName);
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$fileName';
      //  print(filePath);
      final response = await dio.download(url, filePath,
          onReceiveProgress: (fileBytesCount, total) {
        if (fileBytesCount != -1) {
          final progress = (fileBytesCount / total * 100);
          downloadProgress.value = progress;
        }
      }, options: Options(responseType: ResponseType.stream));

      if (response.statusCode == 200) {
        final file = File(filePath);
        if (await file.exists()) {
          //   print('File downloaded successfully: $filePath');
          downloadProgress.value = 100;
          isDownloadStart.value = false;
          saveFileInfo(url, fileName, filePath);
          return true;
        } else {
          print('File not found after download: $filePath');
          return false;
        }
      } else {
        print('Failed to download file: ${response.statusCode}');
        return false;
      }
    } catch (exception) {
      print('Error occurred: $exception');
      isDownloadStart.value = false;
      return false;
    }

    // Try With http package but getting complex to find the progress histroy Try Case 1.0//
    // try {
    //   final response = await http.get(Uri.parse(url));

    //   if (response.statusCode == 200) {
    //     final fileName = url.split('/').last;
    //     final directory = await getExternalStorageDirectory();
    //     print(directory);
    //     final filePath = '${directory!.path}/$fileName';

    //     print(filePath);

    //     final file = File(filePath);
    //     await file.writeAsBytes(response.bodyBytes);

    //     downloadProgress.value = 100;
    //     saveFileInfo(url, fileName);
    //     // downloadedFiles.add(FileModel(url: url, fileName: fileName));

    //     return true;
    //   } else {
    //     print('Failed to download file: ${response.statusCode}');
    //     return false;
    //   }
    // } catch (e) {
    //   print('Error occurred: $e');
    //   return false;
    // }
  }

  Future<void> openDownlaodFile(String filepath, String fileUrl) async{
  
  final file = File(filepath);
  if (await file.exists()) {
  //  var fileFilterString = file.toString().substring(1);
    final result = await OpenFile.open(filepath);
    if (result.type != ResultType.done) {
      Get.snackbar("Ops", "Failed to open file: ${result.message}");
    }
  } else {
    Get.snackbar("Ops", "File does not exist");
  }
  }

  // Save the fileInto in Sp //
  Future<void> saveFileInfo(
      String url, String fileName, String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    // print(url);
    // print(fileName);
    // print(filePath);
    final existingFiles = prefs.getStringList('files') ?? [];
    existingFiles.add('$url-$fileName-$filePath');
    await prefs.setStringList('files', existingFiles);
  }

  // Read the fileInto in Sp //
  Future<void> loadDownloadedFiles() async {
    isLoading.value = true; // Start loading

    final prefs = await SharedPreferences.getInstance();
    final existingFiles = prefs.getStringList('files') ?? [];

    print(existingFiles.length);

    print(existingFiles);

    existingFiles.map((file) {
      final parts = file.split('-');

      downloadedSaveFiles.add(
          FileModel(url: parts[0], fileName: parts[1], filePath: parts[2]));
    }).toList();

    // downloadedSaveFiles.value = existingFiles.map((file) {

    //   final parts = file.split('-');
    // //  print(parts);
    //   return FileModel(url: parts[0], fileName: parts[1], filePath: parts[2]);
    // }).toList();

    isLoading.value = false; // End loading
  }
}
