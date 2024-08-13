import 'package:downlaod_manager/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'routes/route_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await requestPermissions();
  runApp(const MyApp());
}

// Ensure widgets binding for permission requests //
Future<void> requestPermissions() async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    print('Storage permission granted');
    
  } else if (status.isDenied) {
    print('Storage permission denied');
   
  } else if (status.isPermanentlyDenied) {
    print('Storage permission permanently denied');
   
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Download Manager',
      getPages: routes,
      initialRoute: RoutesName.homeScreen,

    );
  }
}