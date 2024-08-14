import 'package:downlaod_manager/screens/Home%20Screen/Controller/file_controller.dart';
import 'package:downlaod_manager/service/db_helper.dart';
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
    // Load File from sharedpreferences //
    fileController.loadDownloadedFiles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: DataBaseHelper().getFileInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.none) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              return ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final file = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          onTap: () async {
                            await fileController.openDownlaodFile(
                                file.filePath, file.url);
                          },
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            "File Name: ${file.fileName}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "File Url: ${file.url}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}


  // For Uses of  sharedpreferences //
   // body: Obx(
        //   () => fileController.isLoading.value == true
        //       ? const Center(child: CircularProgressIndicator())
        //       : ListView.builder(
        //           primary: false,
        //           shrinkWrap: true,
        //           itemCount: fileController.downloadedSaveFiles.length,
        //           itemBuilder: (context, index) {
        //             final file = fileController.downloadedSaveFiles[index];
        //             return Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Card(
        //                 child: ListTile(
        //                  onTap: () async {
        //                    await fileController.openDownlaodFile(file.filePath, file.url);
        //                  },
        //                   leading: CircleAvatar(
        //                     child: Text('${index + 1}'),
        //                   ),
        //                   title: Text("File Name: ${file.fileName}",
        //                     overflow: TextOverflow.ellipsis,
        //                   ),
        //                    subtitle: Text("File Url: ${file.url}", overflow: TextOverflow.ellipsis,),
        //                 ),
        //               ),
        //             );
        //           },
        //         ),
        // ),