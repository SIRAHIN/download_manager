import 'package:downlaod_manager/routes/route_name.dart';
import 'package:downlaod_manager/screens/Home%20Screen/Controller/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController urlController = TextEditingController();
  final FileController fileController = Get.put(FileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download Manager"),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'URL Field is Empty';
                    } else {
                      return null;
                    }
                  },
                  controller: urlController,
                  decoration: const InputDecoration(labelText: 'Enter URL'),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => fileController.isDownloadStart.value == true ?
                  Column(
                    children: [
                      Container(
                       height: 15,
                       width: fileController.downloadProgress.value,
                       color: Colors.red,
                      ),
                      Text("${fileController.downloadProgress.toInt()}%")
                    ],
                  )
                : Container() ),  
                const SizedBox(height: 20),
                SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor: WidgetStatePropertyAll(
                            Colors.deepPurple.withOpacity(0.5))),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool isDownloaded = await fileController
                            .downloadFile(urlController.text);
                        if (isDownloaded) {
                          Get.snackbar(
                              'Congratulations ', 'File Downlaod Successflly');
                          fileController.downloadProgress.value = 0.0;
                          urlController.clear();
                        }
                      } else {
                        Get.snackbar(
                            'Warning ', 'File Not Downlaod Successflly');
                      }
                    },
                    child: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.download_rounded,
          size: 32,
          color: Colors.black,
        ),
        onPressed: () {
          Get.toNamed(RoutesName.downloadedScreen);
        },
      ),
    );
  }
}
