import 'package:get/get.dart';

class Snack{

  static success({required String titre,required String message}){
    Get.snackbar(titre, message,  duration: Duration(seconds: 3) );
  }

  static error({ required String titre,required String message}){
    Get.snackbar(titre, message,  duration: Duration(seconds: 3) );
  }

  static info({required String message}){
    Get.snackbar('Info', message,  duration: Duration(seconds: 3) );
  }



  
  
}