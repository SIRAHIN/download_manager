
import 'package:downlaod_manager/routes/route_name.dart';
import 'package:downlaod_manager/screens/download_list_screen.dart';
import 'package:downlaod_manager/screens/Home%20Screen/home_screen.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
GetPage(name: RoutesName.homeScreen, page: () =>  HomeScreen(),),
GetPage(name: RoutesName.downloadedScreen, page: () =>  DownloadListScreen(),),
];