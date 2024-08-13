import 'package:downlaod_manager/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/route_screen.dart';

void main() => runApp(const MyApp());

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