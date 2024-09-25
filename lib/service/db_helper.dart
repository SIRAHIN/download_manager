
import 'package:downlaod_manager/model/file_model.dart';
import 'package:downlaod_manager/screens/Home%20Screen/Controller/file_controller.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  
  //------------------------------------------------------//
  // Table Column Name //
  String dbTableName = 'download_manager';
  String dbTableIdColumnName = 'id';
  String dbTableFileUrlColumnName = 'file_url';
  String dbTableFileNameColumnName = 'file_name';
  String dbTableFilePathColumnName = 'file_path';
 
 //------------------------------------------------------//
 // Generate Sqflite Database // 
  Future<Database> getDatabaseOpen() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'download_manager.db'),
      version: 1,
      onCreate: (db, version) async {
        return await db.execute(
            'CREATE TABLE  $dbTableName($dbTableIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $dbTableFileUrlColumnName TEXT, $dbTableFileNameColumnName TEXT, $dbTableFilePathColumnName  TEXT)');
      },
    );
  }
  
  //------------------------------------------------------//
  // Insert Data into Database //
  Future<void> insertFileInfo(
      String fileUrl, String fileName, String filePath) async {
  
    final db = await getDatabaseOpen();
  // Insert Query into DB Table //  
    db.insert(
        dbTableName,
        {
          dbTableFileUrlColumnName: fileUrl,
          dbTableFilePathColumnName: filePath,
          dbTableFileNameColumnName: fileName
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //------------------------------------------------------//
  
  // Get All DataBase Data and Set Data into Model Class //
  Future<RxList<FileModel>> getFileInfo() async {
    Get.find<FileController>().downloadedSaveFiles.clear();

    // Ensure Generate Sqflite Database //
    final db = await getDatabaseOpen();

    // Get all Table Data and insert into a List //
    List<Map> dataList = await db.query(dbTableName);

    // Using loop get all individula data and add into 
    //the FileModel data type list (Rx<FileModlel>downloadedSaveFile)
    for (var element in dataList) {
      Get.find<FileController>().downloadedSaveFiles.add(FileModel(
          url: element[dbTableFileUrlColumnName] as String,
          fileName: element[dbTableFileNameColumnName] as String,
          filePath: element[dbTableFilePathColumnName] as String));
    }
    // return the list data for future call //
    return Get.find<FileController>().downloadedSaveFiles;
  }
}
