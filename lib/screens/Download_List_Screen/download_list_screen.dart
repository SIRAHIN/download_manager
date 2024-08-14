import 'package:downlaod_manager/screens/Home%20Screen/Controller/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadListScreen extends StatefulWidget {
  const DownloadListScreen({super.key});

  @override
  State<DownloadListScreen> createState() => _DownloadListScreenState();
}

class _DownloadListScreenState extends State<DownloadListScreen> {
  final fileController = Get.find<FileController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileController.loadDownloadedFiles();
  }

  @override
   Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => fileController.isLoading.value == true
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: fileController.downloadedSaveFiles.length,
                  itemBuilder: (context, index) {
                    final file = fileController.downloadedSaveFiles[index];
                 
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                         onTap: () async {
                           await fileController.openDownlaodFile(file.filePath, file.url);
                         },
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text("File Name: ${file.fileName}",
                            overflow: TextOverflow.ellipsis,
                          ),
                           subtitle: Text("File Url: ${file.url}", overflow: TextOverflow.ellipsis,),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
