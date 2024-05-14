
import 'package:get/get.dart';
import 'package:koumi_app/view/item/item_binding.dart';
import 'package:koumi_app/view/item/item_screen.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.ITEM,
      page: () => ItemScreen(),
      binding: ItemBinding(),
    ),
  ];
}