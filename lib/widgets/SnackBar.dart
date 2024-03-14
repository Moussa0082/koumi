import 'package:get/get.dart';

class Snack{

  static success(

  ){}
  static error(
    
  ){}

  static info({required String message}){
    Get.snackbar('Info', message,  duration: Duration(seconds: 10) );
  }

  
  
}