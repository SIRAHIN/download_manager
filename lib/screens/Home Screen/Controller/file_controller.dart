import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downlaod_manager/model/file_model.dart';
import 'package:downlaod_manager/service/db_helper.dart';
import 'package:open_file/open_file.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileController extends GetxController {
  var downloadProgress = (0.0).obs;
  //var downloadedFiles = <FileModel>[].obs;
  var isDownloadStart = false.obs;
  var downloadedSaveFiles = <FileModel>[].obs;

  var isLoading = false.obs;
  
  //------------------------------------------------------//
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
          //print('File downloaded successfully: $filePath');
          downloadProgress.value = 100;
          isDownloadStart.value = false;
          
          //------------------------------------------------------//
          // Save or Load File into Sqflite //
          DataBaseHelper().insertFileInfo(url, fileName, filePath);
          
          //------------------------------------------------------//
          // Save or Load File into sharedpreferences //
          //saveFileInfo(url, fileName, filePath);
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
  }
  
  //------------------------------------------------------//
  Future<void> openDownlaodFile(String filepath, String fileUrl) async {
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

  //------------------------------------------------------//
  // Save the fileInto into sharedpreferences //
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
  
  //------------------------------------------------------//
  // Read the fileInto from sharedpreferences //
  Future<void> loadDownloadedFiles() async {
    isLoading.value = true; // Start loading

    final prefs = await SharedPreferences.getInstance();
    final existingFiles = prefs.getStringList('files') ?? [];

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
